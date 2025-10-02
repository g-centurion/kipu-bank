# KipuBank Smart Contract

## Descripción

**KipuBank** es un contrato inteligente para la blockchain de Ethereum que funciona como una bóveda de ETH descentralizada y personal. [cite_start]Este proyecto fue desarrollado como parte del Módulo 2 del programa EDP de ETH Kipu. [cite: 1, 3]

El contrato permite a los usuarios:
- [cite_start]**Depositar ETH** de forma segura en una bóveda personal asociada a su dirección. [cite: 19]
- [cite_start]**Retirar ETH** de su bóveda, con un límite máximo por transacción para mayor seguridad. [cite: 20]
- [cite_start]**Seguir un límite global (`bankCap`)** que define la cantidad máxima de ETH que el contrato puede gestionar en total. [cite: 21]

[cite_start]Este contrato implementa buenas prácticas de seguridad en Solidity, incluyendo el patrón **Checks-Effects-Interactions** para prevenir ataques de reentrada [cite: 29][cite_start], el uso de **Errores Personalizados** para un manejo de errores eficiente en gas [cite: 28][cite_start], y una completa documentación **NatSpec**. [cite: 33]

## Instrucciones de Despliegue

[cite_start]Este contrato fue compilado con **Solidity 0.8.26** y está diseñado para ser desplegado en una red de prueba como Sepolia. [cite: 13, 55]

### Requisitos
- Navegador web con [MetaMask](https://metamask.io/) instalado.
- ETH de prueba en la red Sepolia (puedes obtenerlo de un faucet).

### Pasos para el Despliegue con Remix IDE

1.  Abre el código de `KipuBank.sol` en [Remix IDE](https://remix.ethereum.org/).
2.  Ve a la pestaña **"Solidity Compiler"**. Asegúrate de que el compilador esté configurado en la versión `0.8.26`. Haz clic en **"Compile KipuBank.sol"**.
3.  Ve a la pestaña **"Deploy & Run Transactions"**.
4.  En el menú **"ENVIRONMENT"**, selecciona **"Injected Web3"** para conectar Remix con MetaMask. Asegúrate de que MetaMask esté en la red "Sepolia".
5.  En la sección **"Deploy"**, al lado del botón "Deploy", debes proporcionar los dos argumentos para el constructor:
    - `initialBankCap`: El límite total de ETH que el banco puede aceptar (en Wei).
    - `maxWithdrawalAmount`: El límite máximo de retiro por transacción (en Wei).
    
    Por ejemplo, para un límite de 10 ETH y un retiro máximo de 1 ETH, ingresarías: `10000000000000000000, 1000000000000000000`
6.  Haz clic en **"transact"** y confirma la transacción en MetaMask.

## Cómo Interactuar con el Contrato

Una vez desplegado, puedes interactuar con el contrato desde la misma interfaz de Remix, en la sección "Deployed Contracts".

### Depositar ETH
1.  En la sección "Deploy & Run", ingresa la cantidad de ETH que deseas depositar en el campo **"VALUE"** (por ejemplo, `0.5 ether`).
2.  Haz clic en el botón `depositar`.
3.  Confirma la transacción en MetaMask.
4.  Puedes verificar tu saldo llamando a la función `balances` e ingresando tu dirección.

### Retirar ETH
1.  Asegúrate de tener saldo en el contrato.
2.  En la función `withdraw`, ingresa la cantidad que deseas retirar en Wei (ej: `500000000000000000` para 0.5 ETH).
3.  Haz clic en el botón `withdraw` y confirma la transacción.
4.  Verifica que tu saldo en MetaMask haya aumentado y que tu saldo en el contrato haya disminuido.

### Funciones de Lectura (View)
- `bankCap()`: Devuelve el límite total del banco en Wei.
- `MAX_WITHDRAWAL_PER_TX()`: Devuelve el límite de retiro por transacción en Wei.
- `balances(address)`: Devuelve el saldo de una dirección específica.
- `getDepositCount()`: Devuelve el número total de depósitos.
- `getWithdrawalCount()`: Devuelve el número total de retiros.
