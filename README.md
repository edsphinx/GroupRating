### README.md

# 🏗 GroupRating

<h4 align="center">
  <a href="#descripción-general">Descripción General</a> |
  <a href="#instrucciones-de-instalación-y-ejecución">Instalación y Ejecución</a> |
  <a href="#direcciones-de-contratos-verificados">Contratos Verificados</a>
</h4>

🧪 Un contrato inteligente diseñado para facilitar la creación y gestión de equipos, permitiendo que los miembros del equipo califiquen las contribuciones de los demás. Utiliza el Servicio de Atestación de Ethereum (EAS) para registrar estas calificaciones en la blockchain.

## Descripción General

El proyecto `GroupRating` es un sistema descentralizado que permite la creación de equipos y la evaluación de contribuciones dentro de esos equipos. Los miembros pueden calificar las contribuciones de otros miembros, y estas calificaciones se utilizan para distribuir subvenciones proporcionalmente. Este proyecto es útil para cualquier aplicación que necesite un registro confiable de contribuciones y distribuciones de recompensas basadas en esas contribuciones.

### Funcionalidades Principales

- ✅ **Creación de Equipos**: Permite al propietario del contrato crear nuevos equipos y agregar miembros a estos equipos.
- 📝 **Asignación de Calificaciones**: Los miembros del equipo pueden calificar las contribuciones de otros miembros.
- 💰 **Distribución de Subvenciones**: Las subvenciones se distribuyen proporcionalmente entre los miembros del equipo basadas en las calificaciones recibidas.

## Requisitos

Antes de comenzar, necesitas instalar las siguientes herramientas:

- [Node (>= v18.17)](https://nodejs.org/en/download/)
- Yarn ([v1](https://classic.yarnpkg.com/en/docs/install/) o [v2+](https://yarnpkg.com/getting-started/install))
- [Git](https://git-scm.com/downloads)

## Instrucciones de Instalación y Ejecución

### 1. Clonar el Repositorio e Instalar Dependencias

```bash
git clone https://github.com/edsphinx/GroupRating.git
cd GroupRating
yarn install
```

### 2. Ejecutar una Red Local

En la primera terminal, ejecuta:

```bash
yarn chain
```

Este comando inicia una red Ethereum local usando Hardhat. La red se ejecuta en tu máquina local y puede ser utilizada para pruebas y desarrollo. Puedes personalizar la configuración de la red en `hardhat.config.ts`.

### 3. Desplegar el Contrato de Prueba

En una segunda terminal, despliega el contrato de prueba:

```bash
yarn deploy
```

Este comando despliega un contrato inteligente de prueba en la red local. El contrato se encuentra en `packages/hardhat/contracts` y puede ser modificado según tus necesidades. El comando `yarn deploy` usa el script de despliegue ubicado en `packages/hardhat/deploy` para desplegar el contrato en la red. También puedes personalizar el script de despliegue.

### 4. Iniciar la Aplicación NextJS

En una tercera terminal, inicia tu aplicación NextJS:

```bash
yarn start
```

Visita tu aplicación en: `http://localhost:3000`. Puedes interactuar con tu contrato inteligente usando la página `Debug Contracts`. Puedes ajustar la configuración de la aplicación en `packages/nextjs/scaffold.config.ts`.

**Lo siguiente**:

- Edita tu contrato inteligente `GroupRating.sol` en `packages/hardhat/contracts`
- Edita la página principal de tu frontend en `packages/nextjs/app/page.tsx`. Para obtener orientación sobre [rutas](https://nextjs.org/docs/app/building-your-application/routing/defining-routes) y configurar [páginas/layouts](https://nextjs.org/docs/app/building-your-application/routing/pages-and-layouts), consulta la documentación de Next.js.
- Edita tus scripts de despliegue en `packages/hardhat/deploy`
- Edita tus pruebas de contrato inteligente en: `packages/hardhat/test`. Para ejecutar las pruebas utiliza `yarn hardhat:test`

## Direcciones de Contratos Verificados

Incluye enlaces a los contratos verificados en Etherscan o una red de prueba relevante:

- [Contrato GroupRating en ScrollSepolia](https://sepolia.scrollscan.dev/address/0xb9e847f664227f883bce636268d286d38803ec15)

---

Esta guía proporciona una descripción general del proyecto `GroupRating`, las instrucciones de instalación y ejecución, y los enlaces a los contratos verificados. Para cualquier pregunta adicional, consulta la documentación o ponte en contacto con el equipo del proyecto.
