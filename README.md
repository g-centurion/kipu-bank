KipuBank Smart Contract
Descripción
KipuBank es un contrato inteligente para la blockchain de Ethereum que funciona como una bóveda de ETH descentralizada y personal. Este proyecto fue desarrollado como parte del Módulo 2 del programa EDP de ETH Kipu.

El contrato permite a los usuarios:

Depositar ETH: Guarda ETH de forma segura en una bóveda personal asociada a la dirección del usuario.

Retirar ETH: Extrae ETH de la bóveda, con un límite máximo por transacción para mayor seguridad.

Seguir un límite global (bankCap): Define la cantidad máxima de ETH que el contrato puede gestionar en total.

Este contrato implementa buenas prácticas de seguridad en Solidity, incluyendo el patrón Checks-Effects-Interactions para prevenir ataques de reentrada, el uso de Errores Personalizados para un manejo de errores eficiente en gas, y una completa documentación NatSpec.

Instrucciones de Despliegue
Este contrato fue compilado con Solidity 0.8.26 y está diseñado para ser desplegado en una red de prueba como Sepolia.

Requisitos
Navegador web con MetaMask instalado.

ETH de prueba en la red Sepolia. Puedes obtenerlo de faucets como:

ETH Kipu Faucet

PK910 Sepolia Faucet

Pasos para el Despliegue con Remix IDE
Abre el código de KipuBank.sol en Remix IDE.

Ve a la pestaña "Solidity Compiler". Asegúrate de que el compilador esté configurado en la versión 0.8.26. Haz clic en "Compile KipuBank.sol".

Ve a la pestaña "Deploy & Run Transactions".

En el menú "ENVIRONMENT", selecciona "Injected Provider" (o "Injected Web3") para conectar Remix con MetaMask. Asegúrate de que MetaMask esté en la red "Sepolia".

En la sección "Deploy", al lado del botón "Deploy", debes proporcionar los dos argumentos para el constructor:

initialBankCap: El límite total de ETH que el banco puede aceptar (en Wei).

maxWithdrawalAmount: El límite máximo de retiro por transacción (en Wei).

Por ejemplo, para un límite de 10 ETH y un retiro máximo de 1 ETH, ingresarías los valores en Wei de la siguiente forma:
10000000000000000000, 1000000000000000000

Haz clic en "transact" y confirma la transacción en MetaMask.

Cómo Interactuar con el Contrato
Una vez desplegado, puedes interactuar con el contrato desde la misma interfaz de Remix, en la sección "Deployed Contracts".

Depositar ETH
En la sección "Deploy & Run", ingresa la cantidad de ETH que deseas depositar en el campo VALUE (por ejemplo, 0.5 ether).

Haz clic en el botón depositar.

Confirma la transacción en MetaMask.

Puedes verificar tu saldo llamando a la función balances e ingresando tu dirección.

Retirar ETH
Asegúrate de tener saldo en el contrato.

En la función withdraw, ingresa la cantidad que deseas retirar en Wei (ej: 500000000000000000 para 0.5 ETH).

Haz clic en el botón withdraw y confirma la transacción.

Verifica que tu saldo en MetaMask haya aumentado y que tu saldo en el contrato haya disminuido.

Funciones de Lectura (View)
bankCap(): Devuelve el límite total del banco en Wei.

MAX_WITHDRAWAL_PER_TX(): Devuelve el límite de retiro por transacción en Wei.

balances(address): Devuelve el saldo de una dirección específica.

getDepositCount(): Devuelve el número total de depósitos.

getWithdrawalCount(): Devuelve el número total de retiros.
