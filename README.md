# KipuBank Smart Contract

## Descripción

**KipuBank** es un contrato inteligente para la blockchain de Ethereum que funciona como una bóveda de ETH descentralizada y personal. Este proyecto fue desarrollado como parte del Módulo 2 del programa EDP de ETH Kipu.

El contrato implementa buenas prácticas de seguridad en Solidity, incluyendo el patrón **Checks-Effects-Interactions** para prevenir ataques de reentrada, el uso de **Errores Personalizados** para un manejo de errores eficiente en gas, y una completa documentación **NatSpec**.

---

## Características Principales

-   **Depósitos de ETH:** Guarda ETH de forma segura en una bóveda personal asociada a la dirección del usuario.
-   **Retiros de ETH:** Extrae ETH de la bóveda, con un límite máximo por transacción para mayor seguridad.
-   **Límite Global (`bankCap`):** Define la cantidad máxima de ETH que el contrato puede gestionar en total.
-   **Seguridad:** Diseñado siguiendo las mejores prácticas para minimizar riesgos.
-   **Transparencia:** Emite eventos para cada depósito y retiro, permitiendo un seguimiento fácil de la actividad.

---

## Solidity API
<details>
A continuación se detalla la interfaz pública del contrato `KipuBank`.

**Contrato:** `KipuBank` (`contracts/KipuBank.sol`)

### Modificadores

#### `onlyOwner`

```solidity
modifier onlyOwner()
````

Limita la ejecución de la función solo al dueño del contrato (Requisito: Modificador).

-----

### Funciones

#### `constructor`

```solidity
constructor(uint256 initialBankCap, uint256 maxWithdrawalAmount) public
```

Inicializa la capacidad máxima del banco y el límite de retiro por transacción.

**Parámetros:**

| Nombre                | Tipo    | Descripción                                                                 |
| --------------------- | ------- | --------------------------------------------------------------------------- |
| `initialBankCap`      | uint256 | El límite total de ETH que el banco puede contener (en Wei).                |
| `maxWithdrawalAmount` | uint256 | El límite máximo de ETH que se puede retirar en una transacción (en Wei). |

#### `deposit`

```solidity
function deposit() external payable
```

Permite a los usuarios depositar ETH en su bóveda personal (Requisito: `external payable`).

#### `withdraw`

```solidity
function withdraw(uint256 amountToWithdraw) external
```

Permite a los usuarios retirar ETH de su bóveda, sujeto al límite de transacción.

**Parámetros:**

| Nombre             | Tipo    | Descripción                             |
| ------------------ | ------- | --------------------------------------- |
| `amountToWithdraw` | uint256 | La cantidad de ETH (en Wei) a retirar. |

#### `getDepositCount`

```solidity
function getDepositCount() external view returns (uint256)
```

Retorna el número total de depósitos realizados en el contrato.

**Valores de Retorno:**

| Nombre | Tipo    | Descripción                     |
| ------ | ------- | ------------------------------- |
| `[0]`  | uint256 | El conteo total de depósitos.   |

#### `getWithdrawalCount`

```solidity
function getWithdrawalCount() external view returns (uint256)
```

Retorna el número total de retiros realizados en el contrato.

**Valores de Retorno:**

| Nombre | Tipo    | Descripción                   |
| ------ | ------- | ----------------------------- |
| `[0]`  | uint256 | El conteo total de retiros.   |

-----

### Eventos

#### `DepositSuccessful`

```solidity
event DepositSuccessful(address user, uint256 amount)
```

Se emite cuando un usuario deposita ETH.

**Parámetros:**

| Nombre   | Tipo    | Descripción                                |
| -------- | ------- | ------------------------------------------ |
| `user`   | address | La dirección que realizó el depósito.      |
| `amount` | uint256 | La cantidad de ETH depositada (en Wei).    |

#### `WithdrawalSuccessful`

```solidity
event WithdrawalSuccessful(address user, uint256 amount)
```

Se emite cuando un usuario retira ETH.

**Parámetros:**

| Nombre   | Tipo    | Descripción                              |
| -------- | ------- | ---------------------------------------- |
| `user`   | address | La dirección que realizó el retiro.      |
| `amount` | uint256 | La cantidad de ETH retirada (en Wei).    |

-----

</details>

---


## Instrucciones de Despliegue
<details>
Este contrato fue compilado con **Solidity 0.8.26** y está diseñado para ser desplegado en una red de prueba como Sepolia.

### Requisitos

  - Navegador web con [MetaMask](https://metamask.io/) instalado.
  - ETH de prueba en la red Sepolia. Puedes obtenerlo de faucets como:
      - [ETH Kipu Faucet](https://faucet.ethkipu.org/)
      - [PK910 Sepolia Faucet](https://sepolia-faucet.pk910.de/)

### Pasos para el Despliegue con Remix IDE

1.  Abre el código de `KipuBank.sol` en [Remix IDE](https://remix.ethereum.org/).

2.  Ve a la pestaña **"Solidity Compiler"**. Asegúrate de que el compilador esté configurado en la versión `0.8.26`. Haz clic en **"Compile KipuBank.sol"**.

3.  Ve a la pestaña **"Deploy & Run Transactions"**.

4.  En el menú **"ENVIRONMENT"**, selecciona **"Injected Provider"** (o "Injected Web3") para conectar Remix con MetaMask. Asegúrate de que MetaMask esté en la red "Sepolia".

5.  En la sección **"Deploy"**, al lado del botón "Deploy", debes proporcionar los dos argumentos para el constructor:

      - `initialBankCap`: El límite total de ETH que el banco puede aceptar (en Wei).
      - `maxWithdrawalAmount`: El límite máximo de retiro por transacción (en Wei).

    *Por ejemplo, para un límite de 1 ETH y un retiro máximo de 0.1 ETH, ingresarías los valores en Wei de la siguiente forma:*
    `1 ETH = 1000000000000000000 wei`, `0.1 ETH = 100000000000000000 wei`

    ## Tabla de Conversión: ETH a Wei

    Tabla de referencia con valores comunes de ETH y su equivalente en Wei para usar en los casos pruebas y transacciones.
    
    | Descripción          | Valor en ETH      | Valor en Wei                 |
    | :------------------- | :---------------- | :--------------------------- |
    | Un ETH               | `1`               | `1000000000000000000`        |
    | Medio ETH            | `0.5`             | `500000000000000000`         |
    | Un Gwei (para gas)   | `0.000000001`     | `1000000000`                 |
    | Cantidad pequeña     | `0.0123`          | `12300000000000000`          |
    | Cantidad media       | `15.5`            | `15500000000000000000`       |
    | Cantidad grande      | `100`             | `100000000000000000000`      |
    | Cantidad muy grande  | `2500`            | `2500000000000000000000`     |

6.  Haz clic en **"transact"** y confirma la transacción en MetaMask.

## Cómo Interactuar con el Contrato

Una vez desplegado, puedes interactuar con el contrato desde la misma interfaz de Remix, en la sección "Deployed Contracts".

### Depositar ETH

1.  En la sección "Deploy & Run", ingresa la cantidad de ETH que deseas depositar en el campo **`VALUE`** (por ejemplo, `0.5 ether`).
2.  Haz clic en el botón `depositar`.
3.  Confirma la transacción en MetaMask.
4.  Puedes verificar tu saldo llamando a la función `balances` e ingresando tu dirección.

### Retirar ETH

1.  Asegúrate de tener saldo en el contrato.
2.  En la función `withdraw`, ingresa la cantidad que deseas retirar en Wei (ej: `100000000000000000` para 0.1 ETH).
3.  Haz clic en el botón `withdraw` y confirma la transacción.
4.  Verifica que tu saldo en MetaMask haya aumentado y que tu saldo en el contrato haya disminuido.

### Funciones de Lectura (View)

  - `bankCap()`: Devuelve el límite total del banco en Wei.
  - `MAX_WITHDRAWAL_PER_TX()`: Devuelve el límite de retiro por transacción en Wei.
  - `balances(address)`: Devuelve el saldo de una dirección específica.
  - `getDepositCount()`: Devuelve el número total de depósitos.
  - `getWithdrawalCount()`: Devuelve el número total de retiros.

</details>

----
## Casos de Prueba

<details>
  <summary><strong>Haga clic aquí para ver los casos de prueba sugeridos</strong></summary>

  A continuación, se presenta el plan de pruebas asumiendo los siguientes límites en el constructor:
  - **`MAX_WITHDRAWAL_PER_TX`**: 0.1 ETH.
  - **`bankCap`**: 1 ETH.

  ### FASE 1: Configuración y Verificación de Constantes (Lectura)

| ID | Función/Variable | Cuenta | Acción en Remix | Resultado Esperado | Requisito a Cubrir |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 1.1 | `bankCap()` | Usuario A | Clic en el botón azul. | Retorna `1 ETH` (en Wei). | Variable inmutable. |
| 1.2 | `MAX_WITHDRAWAL_PER_TX()` | Usuario A | Clic en el botón azul. | Retorna `0.1 ETH` (en Wei). | Variable inmutable. |
| 1.3 | `getDepositCount()` | Usuario B | Clic en el botón azul. | Debe retornar `0`. | Función `external view`. |
| 1.4 | `_getInternalBalance` | Usuario A | Intentar invocarla. | Fallo. No es visible ni invocable. | Función `private`. |

  ### FASE 2: Pruebas de Depósito (`depositar`)

  Se verifica la lógica `payable`, el límite de `bankCap` y la emisión del evento `DepositSuccessful`.

| ID | Acción (Input en Remix) | Cuenta | Resultado Esperado | Verificación Posterior | Requisito de Seguridad |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 2.1 | **Éxito**: Depositar `0.5 ETH`. | Usuario A | Transacción exitosa. | `balances(A)` es `0.5 ETH`. `getDepositCount()` es `1`. | `payable` y acumulación de saldo. |
| 2.2 | **Éxito**: Depositar `0.1 ETH`. | Usuario B | Transacción exitosa. | `balances(B)` es `0.1 ETH`. `getDepositCount()` es `2`. | Integridad del estado. |
| 2.3 | **Fallo (Exceso de Límite Global)**: Intentar depositar `1 ETH`. | Usuario B | La transacción debe **REVERTIR**. | Falla con el error `Bank__DepositExceedsCap`. | Uso de errores personalizados. |
| 2.4 | **Verificación Post-Fallo**: Revisar después del fallo 2.3. | N/A | El estado no debe cambiar. | `getDepositCount()` debe seguir siendo `2`. | Propiedad de reversión. |
| 2.5 | **Emisión de Evento**: Revisar logs de la transacción 2.1. | Usuario A | Evento `DepositSuccessful` emitido. | El log muestra el evento para Usuario A y `0.5 ETH`. | Emisión de eventos. |

  ### FASE 3: Pruebas de Retiro (`withdraw`)
  Esta fase prueba límites, manejo de errores y, lo más importante, el cumplimiento del patrón **Checks-Effects-Interactions (CEI)**.

| ID | Acción (Input en Remix) | Cuenta | Resultado Esperado | Verificación Posterior | Requisito de Seguridad |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 3.1 | **Fallo (Exceso Límite TX)**: Retirar `0.2 ETH`. | Usuario A | La transacción debe **REVERTIR**. | Falla con error `Bank__WithdrawalExceedsLimit`. | Límite `MAX_WITHDRAWAL_PER_TX`. |
| 3.2 | **Fallo (Saldo Insuficiente)**: Retirar `0.5 ETH` (Saldo B es `0.1 ETH`). | Usuario B | La transacción debe **REVERTIR**. | Falla con error `Bank__InsufficientBalance`. | Validación de saldo. |
| 3.3 | **Retiro Exitoso**: Retirar `0.1 ETH`. | Usuario A | Transacción exitosa. | `balances(A)` es `0.3 ETH`. `getWithdrawalCount()` es `1`. | Lógica de retiro. |
| 3.4 | **Verificación Evento**: Revisar logs de TX 3.3. | Usuario A | Evento `WithdrawalSuccessful` emitido. | El log muestra el evento para Usuario A y `0.2 ETH`. | Emisión de eventos. |
| 3.5 | **Verificación CEI (Debugger)**: Usar el Debugger en TX 3.3. | Usuario A | El saldo se actualiza **ANTES** de la transferencia externa. | El `balances(A)` se actualiza (EFFECTS) antes de la línea `call{value: ...}` (INTERACTION). | Cumplimiento del patrón CEI. |
| 3.6 | **Verificación Transferencia Segura**: Revisar TX 3.3 en Etherscan. | Usuario A | Se usó `call`. | El gas utilizado es mayor a 2300, confirmando el uso de `.call()` en lugar de `.transfer()`. | Manejo seguro de transferencias. |

  ### FASE 4: Control de Acceso (`onlyOwner`)

| ID | Función/Requisito | Cuenta | Acción (Input en Remix) | Resultado Esperado | Requisito de Seguridad |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 4.1 | `onlyOwner` (Simulación) | Usuario B | Si existiera una función `setBankCap()` con `onlyOwner`, el Usuario B intenta llamarla. | La transacción debe **REVERTIR**. | Debe fallar con el error `Bank__Unauthorized`. |

</details>
