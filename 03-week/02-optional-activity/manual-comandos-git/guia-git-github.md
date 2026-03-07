# Guía Completa de Git y GitHub

## Tabla de Contenidos
1. [Introducción](#introducción)
2. [Configuración Inicial](#configuración-inicial)
3. [Creando Commits](#creando-commits)
4. [Comandos Esenciales](#comandos-esenciales)
5. [Ramas (Branches)](#ramas-branches)
6. [Trabajando con GitHub](#trabajando-con-github)
7. [Comandos Avanzados](#comandos-avanzados)
8. [Buenas Prácticas](#buenas-prácticas)

---

## Introducción

Git es un sistema de control de versiones distribuido que te permite rastrear cambios en tu código. GitHub es una plataforma basada en la web que aloja repositorios Git.

---

## Configuración Inicial

### Configurar tu identidad

```bash
# Configurar tu nombre
git config --global user.name "Tu Nombre"

# Configurar tu email
git config --global user.email "tuemail@example.com"

# Verificar configuración
git config --list
```

### Configurar editor predeterminado

```bash
# Visual Studio Code
git config --global core.editor "code --wait"

# Vim
git config --global core.editor "vim"

# Nano
git config --global core.editor "nano"
```

---

## Creando Commits

### Flujo básico de un commit

```bash
# 1. Verificar el estado de tu repositorio
git status

# 2. Agregar archivos al staging area
git add nombre-archivo.txt          # Agregar un archivo específico
git add .                           # Agregar todos los archivos modificados
git add *.js                        # Agregar todos los archivos .js

# 3. Crear el commit
git commit -m "Mensaje descriptivo del commit"

# Commit con mensaje detallado (abre editor)
git commit

# Agregar y hacer commit en un solo paso (solo archivos ya rastreados)
git commit -am "Mensaje del commit"
```

### Estructura de un buen mensaje de commit

```
<tipo>: <descripción breve>

[cuerpo opcional con más detalles]

[footer opcional]
```

**Tipos comunes:**
- `feat:` Nueva funcionalidad
- `fix:` Corrección de bug
- `docs:` Cambios en documentación
- `style:` Formato, sin cambios de código
- `refactor:` Refactorización de código
- `test:` Agregar o modificar tests
- `chore:` Tareas de mantenimiento

**Ejemplos:**

```bash
git commit -m "feat: agregar función de login de usuarios"

git commit -m "fix: corregir error en validación de email"

git commit -m "docs: actualizar README con instrucciones de instalación"
```

### Modificar commits

```bash
# Modificar el último commit (agregar archivos olvidados o cambiar mensaje)
git commit --amend -m "Nuevo mensaje"

# Agregar archivos al último commit
git add archivo-olvidado.txt
git commit --amend --no-edit
```

---

## Comandos Esenciales

### Inicializar y clonar repositorios

```bash
# Crear un nuevo repositorio local
git init

# Clonar un repositorio existente
git clone https://github.com/usuario/repositorio.git

# Clonar en un directorio específico
git clone https://github.com/usuario/repositorio.git nombre-carpeta
```

### Ver historial

```bash
# Ver historial de commits
git log

# Ver historial resumido (una línea por commit)
git log --oneline

# Ver historial con gráfico de ramas
git log --oneline --graph --all

# Ver últimos N commits
git log -n 5

# Ver commits de un autor específico
git log --author="Nombre"

# Ver commits en un rango de fechas
git log --since="2024-01-01" --until="2024-12-31"
```

### Ver cambios

```bash
# Ver cambios no agregados al staging
git diff

# Ver cambios en el staging area
git diff --staged

# Ver cambios de un archivo específico
git diff nombre-archivo.txt

# Ver cambios entre commits
git diff commit1 commit2
```

### Deshacer cambios

```bash
# Descartar cambios en un archivo (NO agregado al staging)
git checkout -- nombre-archivo.txt

# Sacar archivo del staging area (mantener cambios)
git reset nombre-archivo.txt

# Descartar todos los cambios locales
git reset --hard

# Revertir un commit específico (crea un nuevo commit)
git revert <hash-del-commit>

# Volver a un commit anterior (¡CUIDADO! Borra historial)
git reset --hard <hash-del-commit>
```

### Stash (guardar cambios temporalmente)

```bash
# Guardar cambios temporalmente
git stash

# Guardar con un mensaje descriptivo
git stash save "Trabajo en progreso en feature X"

# Listar stashes guardados
git stash list

# Aplicar el último stash
git stash apply

# Aplicar y eliminar el último stash
git stash pop

# Aplicar un stash específico
git stash apply stash@{2}

# Eliminar un stash
git stash drop stash@{0}

# Eliminar todos los stashes
git stash clear
```

---

## Ramas (Branches)

### Crear y gestionar ramas

```bash
# Listar todas las ramas
git branch

# Listar ramas remotas
git branch -r

# Listar todas las ramas (locales y remotas)
git branch -a

# Crear una nueva rama
git branch nombre-rama

# Cambiar a una rama
git checkout nombre-rama

# Crear y cambiar a una nueva rama (atajo)
git checkout -b nombre-rama

# Cambiar a una rama (método moderno)
git switch nombre-rama

# Crear y cambiar a una nueva rama (método moderno)
git switch -c nombre-rama

# Renombrar una rama
git branch -m nombre-antiguo nombre-nuevo

# Eliminar una rama local
git branch -d nombre-rama

# Eliminar una rama forzadamente
git branch -D nombre-rama

# Eliminar una rama remota
git push origin --delete nombre-rama
```

### Fusionar ramas (Merge)

```bash
# Fusionar una rama en la rama actual
git merge nombre-rama

# Fusionar sin fast-forward (siempre crea commit de merge)
git merge --no-ff nombre-rama

# Abortar un merge en progreso
git merge --abort
```

### Rebase

```bash
# Rebase de la rama actual sobre otra rama
git rebase nombre-rama

# Continuar después de resolver conflictos
git rebase --continue

# Saltar un commit durante rebase
git rebase --skip

# Abortar el rebase
git rebase --abort

# Rebase interactivo (para editar historial)
git rebase -i HEAD~3  # Últimos 3 commits
```

---

## Trabajando con GitHub

### Conectar con repositorio remoto

```bash
# Agregar un remoto
git remote add origin https://github.com/usuario/repositorio.git

# Ver remotos configurados
git remote -v

# Cambiar URL del remoto
git remote set-url origin https://github.com/usuario/nuevo-repo.git

# Eliminar un remoto
git remote remove origin
```

### Push (enviar cambios)

```bash
# Enviar cambios al remoto
git push origin nombre-rama

# Enviar todos los commits por primera vez
git push -u origin main

# Enviar todas las ramas
git push --all

# Enviar tags
git push --tags

# Forzar push (¡CUIDADO!)
git push --force
```

### Pull (obtener cambios)

```bash
# Obtener y fusionar cambios del remoto
git pull origin nombre-rama

# Pull con rebase en lugar de merge
git pull --rebase origin nombre-rama
```

### Fetch (descargar sin fusionar)

```bash
# Descargar cambios sin fusionar
git fetch origin

# Descargar de todas las ramas
git fetch --all

# Ver ramas remotas después de fetch
git branch -r
```

### Pull Requests (flujo típico)

```bash
# 1. Crear una nueva rama
git checkout -b feature/nueva-funcionalidad

# 2. Hacer cambios y commits
git add .
git commit -m "feat: implementar nueva funcionalidad"

# 3. Enviar la rama a GitHub
git push -u origin feature/nueva-funcionalidad

# 4. Ir a GitHub y crear el Pull Request
# 5. Después de aprobar y fusionar, actualizar main local
git checkout main
git pull origin main

# 6. Eliminar la rama local
git branch -d feature/nueva-funcionalidad
```

### Fork y contribuciones

```bash
# 1. Fork el repositorio en GitHub

# 2. Clonar tu fork
git clone https://github.com/tu-usuario/repositorio-forkeado.git

# 3. Agregar el repositorio original como upstream
git remote add upstream https://github.com/usuario-original/repositorio.git

# 4. Mantener tu fork actualizado
git fetch upstream
git checkout main
git merge upstream/main
git push origin main

# 5. Crear rama para tu contribución
git checkout -b fix/corregir-bug

# 6. Hacer cambios, commit y push
git add .
git commit -m "fix: corregir bug en función X"
git push origin fix/corregir-bug

# 7. Crear Pull Request en GitHub desde tu fork al repo original
```

---

## Comandos Avanzados

### Tags (etiquetas)

```bash
# Crear tag ligero
git tag v1.0.0

# Crear tag anotado (recomendado)
git tag -a v1.0.0 -m "Versión 1.0.0 - Release inicial"

# Listar tags
git tag

# Ver información de un tag
git show v1.0.0

# Enviar tags al remoto
git push origin v1.0.0

# Enviar todos los tags
git push origin --tags

# Eliminar tag local
git tag -d v1.0.0

# Eliminar tag remoto
git push origin --delete v1.0.0
```

### Cherry-pick

```bash
# Aplicar un commit específico a la rama actual
git cherry-pick <hash-del-commit>

# Cherry-pick múltiples commits
git cherry-pick <hash1> <hash2> <hash3>

# Cherry-pick sin hacer commit automáticamente
git cherry-pick -n <hash-del-commit>
```

### Buscar en el código

```bash
# Buscar en archivos rastreados
git grep "texto-a-buscar"

# Buscar con número de línea
git grep -n "texto-a-buscar"

# Buscar en un commit específico
git grep "texto-a-buscar" <hash-del-commit>
```

### Bisect (encontrar bugs)

```bash
# Iniciar bisect
git bisect start

# Marcar commit actual como malo
git bisect bad

# Marcar un commit antiguo como bueno
git bisect good <hash-del-commit>

# Git irá probando commits intermedios
# Marca cada uno como good o bad
git bisect good
# o
git bisect bad

# Finalizar bisect
git bisect reset
```

### Submodules

```bash
# Agregar un submódulo
git submodule add https://github.com/usuario/repo.git path/to/submodule

# Clonar repositorio con submódulos
git clone --recursive https://github.com/usuario/repo.git

# Inicializar submódulos en un repo ya clonado
git submodule init
git submodule update

# Actualizar todos los submódulos
git submodule update --remote
```

---

## Buenas Prácticas

### Commits

✅ **Hacer:**
- Commits pequeños y frecuentes
- Mensajes descriptivos y claros
- Un commit por cada cambio lógico
- Probar el código antes de hacer commit

❌ **Evitar:**
- Commits gigantes con muchos cambios
- Mensajes vagos como "fix" o "update"
- Mezclar cambios no relacionados en un commit
- Hacer commit de código que no funciona

### Ramas

```bash
# Nomenclatura recomendada:
feature/nombre-funcionalidad    # Nuevas funcionalidades
fix/descripcion-bug            # Correcciones de bugs
hotfix/problema-urgente        # Correcciones urgentes en producción
release/v1.2.0                 # Preparación de releases
docs/actualizar-readme         # Cambios en documentación
```

### Workflow recomendado (Git Flow simplificado)

```bash
# Rama principal: main (siempre estable, lista para producción)
# Rama de desarrollo: develop (integración de features)

# 1. Crear feature desde develop
git checkout develop
git checkout -b feature/nueva-funcionalidad

# 2. Trabajar en la feature
git add .
git commit -m "feat: implementar funcionalidad X"

# 3. Finalizar feature
git checkout develop
git merge feature/nueva-funcionalidad
git branch -d feature/nueva-funcionalidad

# 4. Crear release
git checkout -b release/v1.1.0
# Hacer ajustes finales
git checkout main
git merge release/v1.1.0
git tag -a v1.1.0 -m "Release 1.1.0"

# 5. Merge a develop también
git checkout develop
git merge release/v1.1.0
git branch -d release/v1.1.0
```

### Archivo .gitignore

```bash
# Crear archivo .gitignore en la raíz del proyecto
# Ejemplos de contenido:

# Node.js
node_modules/
npm-debug.log

# Python
__pycache__/
*.py[cod]
.env

# Archivos del sistema
.DS_Store
Thumbs.db

# IDEs
.vscode/
.idea/
*.swp

# Archivos de build
dist/
build/
*.log
```

### Comandos útiles del día a día

```bash
# Ver estado resumido
git status -s

# Ver último commit
git log -1

# Ver quién modificó cada línea de un archivo
git blame nombre-archivo.txt

# Limpiar archivos no rastreados
git clean -n  # Vista previa
git clean -f  # Ejecutar limpieza

# Ver tamaño del repositorio
git count-objects -vH

# Optimizar repositorio
git gc

# Verificar integridad del repositorio
git fsck
```

---

## Recursos Adicionales

- **Documentación oficial de Git:** https://git-scm.com/doc
- **GitHub Docs:** https://docs.github.com
- **Git Cheat Sheet:** https://training.github.com/downloads/es_ES/github-git-cheat-sheet/
- **Visualizador de Git:** https://git-school.github.io/visualizing-git/

---

## Atajos de teclado útiles

```bash
# Crear alias para comandos frecuentes
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.lg "log --oneline --graph --all --decorate"

# Uso:
git co main        # En lugar de git checkout main
git st             # En lugar de git status
git lg             # Log bonito con gráfico
```

---

**Última actualización:** Marzo 2026

¡Happy coding! 🚀
