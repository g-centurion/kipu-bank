// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// =========================================================================
// DOCUMENTACIÓN NATSENEC DEL CONTRATO
// =========================================================================

/// @title KipuBank
/// @author g-centurion
/// @notice Contrato de bóveda que permite a los usuarios depositar ETH y retirarlo con un límite de transacción.
contract KipuBank {

    // ===============================================================
    // ERRORES PERSONALIZADOS (Requisito: usar errores personalizados 
    // ===============================================================

    /// @dev Se lanza cuando el monto depositado excede la capacidad restante del banco.
    error Bank__DepositExceedsCap(uint256 currentBalance, uint256 bankCap, uint256 attemptedDeposit);

    /// @dev Se lanza cuando el monto solicitado excede el límite de retiro por transacción.
    error Bank__WithdrawalExceedsLimit(uint256 limit, uint256 requested);

    /// @dev Se lanza cuando el usuario intenta retirar más de su saldo disponible.
    error Bank__InsufficientBalance(uint256 available, uint256 requested);

    /// @dev Se lanza cuando una transferencia de ETH falla.
    error Bank__TransferFailed();

    /// @dev Se lanza cuando una función solo para el dueño es llamada por otro usuario.
    error Bank__Unauthorized();

    // ===================================
    // EVENTOS (Requisito: Emitir eventos
    // ===================================

    /// @dev Se emite cuando un usuario deposita ETH.
    /// @param user La dirección que realizó el depósito.
    /// @param amount La cantidad de ETH depositada (en Wei).
    event DepositSuccessful(address indexed user, uint256 amount);

    /// @dev Se emite cuando un usuario retira ETH.
    /// @param user La dirección que realizó el retiro.
    /// @param amount La cantidad de ETH retirada (en Wei).
    event WithdrawalSuccessful(address indexed user, uint256 amount);

    // =========================================================================
    // VARIABLES DE ESTADO (Requisito: Immutables, Mappings, Contadores [2, 3, 23])
    // =========================================================================

    /// @dev Límite global de depósitos para el contrato (fijado en el constructor).
    uint256 public immutable bankCap;

    /// @dev Umbral fijo máximo que un usuario puede retirar en una sola transacción.
    uint256 public immutable MAX_WITHDRAWAL_PER_TX;
    
    /// @dev Dirección del desplegador del contrato para control de acceso.
    address private immutable _owner;

    /// @dev Mapeo de la dirección del usuario a su saldo de ETH (en Wei).
    mapping(address => uint256) public balances;

    /// @dev Conteo total de depósitos exitosos.
    uint256 private _depositCount = 0;

    /// @dev Conteo total de retiros exitosos.
    uint256 private _withdrawalCount = 0;

    // =========================================================================
    // CONSTRUCTOR Y MODIFICADORES
    // =========================================================================

    /// @dev Inicializa la capacidad máxima del banco y el límite de retiro por transacción.
    /// @param initialBankCap El límite total de ETH que el banco puede contener (en Wei).
    /// @param maxWithdrawalAmount El límite máximo de ETH que se puede retirar en una transacción (en Wei).
    constructor(uint256 initialBankCap, uint256 maxWithdrawalAmount) {
        bankCap = initialBankCap;
        MAX_WITHDRAWAL_PER_TX = maxWithdrawalAmount;
        _owner = msg.sender;
    }

    /// @dev Limita la ejecución de la función solo al dueño del contrato (Requisito: Modificador [23]).
    modifier onlyOwner() {
        if (msg.sender != _owner) revert Bank__Unauthorized();
        _;
    }

    // =========================================================================
    // FUNCIONES EXTERNAS Y PÚBLICAS
    // =========================================================================

    /// @dev Permite a los usuarios depositar ETH en su bóveda personal (Requisito: external payable [23]).
    function deposit() external payable {
        // A. CHECKS
        // Se calcula el balance actual (incluyendo el depósito) y se verifica contra el límite [2].
        if (address(this).balance > bankCap) {
            revert Bank__DepositExceedsCap(address(this).balance, bankCap, msg.value);
        }
        
        // B. EFFECTS
        balances[msg.sender] += msg.value;
        _depositCount++; 

        // C. INTERACTIONS
        // Se emite el evento solo después de que el estado se ha modificado.
        emit DepositSuccessful(msg.sender, msg.value);
    }

    /// @dev Permite a los usuarios retirar ETH de su bóveda, sujeto al límite de transacción.
    /// @param amountToWithdraw La cantidad de ETH (en Wei) a retirar.
    function withdraw(uint256 amountToWithdraw) external {
        // A. CHECKS
        if (amountToWithdraw > MAX_WITHDRAWAL_PER_TX) {
            revert Bank__WithdrawalExceedsLimit(MAX_WITHDRAWAL_PER_TX, amountToWithdraw);
        }

        if (balances[msg.sender] < amountToWithdraw) {
            revert Bank__InsufficientBalance(balances[msg.sender], amountToWithdraw);
        }

        // B. EFFECTS (Patrón Checks-Effects-Interactions)
        // Se actualiza el estado antes de la llamada externa para prevenir reentrancy [6, 28].
        balances[msg.sender] -= amountToWithdraw;
        _withdrawalCount++;

        // C. INTERACTIONS
        // Se utiliza la función de bajo nivel `call` para transferir ETH de forma segura,
        // ya que `transfer` y `send` limitan el gas a 2300, lo que puede fallar [29, 31].
        (bool success, ) = payable(msg.sender).call{value: amountToWithdraw}("");

        if (!success) {
            revert Bank__TransferFailed();
        }

        emit WithdrawalSuccessful(msg.sender, amountToWithdraw);
    }
    
    // =========================================================================
    // FUNCIONES INTERNAS Y DE VISTA
    // =========================================================================
    
    // Función privada (Requisito: una función privada [23])
    
    /// @dev Retorna el saldo privado de un usuario. Es una función auxiliar interna.
    /// @param user La dirección del usuario.
    /// @return El saldo del usuario.
    function _getInternalBalance(address user) private view returns (uint256) {
        return balances[user];
    }

    // Funciones de vista (Requisito: una función external view [23])

    /// @dev Retorna el número total de depósitos realizados en el contrato.
    /// @return El conteo total de depósitos.
    function getDepositCount() external view returns (uint256) {
        return _depositCount;
    }

    /// @dev Retorna el número total de retiros realizados en el contrato.
    /// @return El conteo total de retiros.
    function getWithdrawalCount() external view returns (uint256) {
        return _withdrawalCount;
    }
}
