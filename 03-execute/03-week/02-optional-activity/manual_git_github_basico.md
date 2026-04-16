# Manual básico de Git y GitHub

## Introducción

**Git** es un sistema de control de versiones que permite guardar cambios en tus proyectos.
**GitHub** es una plataforma en línea donde puedes almacenar tus repositorios Git y compartirlos.

Este manual te enseñará lo básico para empezar.

---

# 1. Instalar Git

Descarga Git desde:

https://git-scm.com/

Después de instalarlo, verifica en la terminal:

```bash
git --version
```

Si aparece la versión, Git está instalado correctamente.

---

# 2. Configurar Git por primera vez

Configura tu nombre y correo:

```bash
git config --global user.name "Tu Nombre"
git config --global user.email "tucorreo@email.com"
```

Verifica la configuración:

```bash
git config --list
```

---

# 3. Crear un repositorio local

Ve a la carpeta de tu proyecto y ejecuta:

```bash
git init
```

Esto crea un repositorio Git en esa carpeta.

---

# 4. Ver el estado del proyecto

Para ver archivos modificados o pendientes:

```bash
git status
```

---

# 5. Agregar archivos al área de preparación

Agregar un archivo:

```bash
git add archivo.txt
```

Agregar todos los archivos:

```bash
git add .
```

---

# 6. Guardar cambios con commit

```bash
git commit -m "Primer commit"
```

El mensaje debe describir los cambios realizados.

---

# 7. Ver historial de commits

```bash
git log
```

Versión resumida:

```bash
git log --oneline
```

---

# 8. Crear un repositorio en GitHub

1. Entra a GitHub.
2. Inicia sesión.
3. Haz clic en **New repository**.
4. Ponle nombre.
5. Crea el repositorio.

---

# 9. Conectar proyecto local con GitHub

Copia la URL del repositorio y ejecuta:

```bash
git remote add origin https://github.com/usuario/repositorio.git
```

Verifica la conexión:

```bash
git remote -v
```

---

# 10. Subir archivos a GitHub

Primera vez:

```bash
git branch -M main
git push -u origin main
```

Luego:

```bash
git push
```

---

# 11. Descargar un repositorio existente

```bash
git clone https://github.com/usuario/repositorio.git
```

---

# 12. Traer cambios del repositorio remoto

```bash
git pull
```

---

# 13. Flujo básico de trabajo

Cada vez que hagas cambios:

```bash
git add .
git commit -m "Descripción del cambio"
git push
```

---

# 14. Crear ramas

Crear una rama:

```bash
git branch nombre-rama
```

Cambiar de rama:

```bash
git checkout nombre-rama
```

Crear y cambiar en un solo paso:

```bash
git checkout -b nombre-rama
```

---

# 15. Unir ramas

Primero cambia a la rama principal:

```bash
git checkout main
```

Luego une la rama:

```bash
git merge nombre-rama
```

---

# 16. Comandos más usados

```bash
git init
git status
git add .
git commit -m "mensaje"
git push
git pull
git clone URL
git branch
git checkout rama
```

---

# 17. Recomendaciones

- Haz commits frecuentes.
- Usa mensajes claros en cada commit.
- Usa ramas para nuevas funcionalidades.
- Haz `git pull` antes de `git push`.
- Mantén tu repositorio ordenado.

---

# 18. Ejemplo práctico

```bash
git init
git add .
git commit -m "Proyecto inicial"
git branch -M main
git remote add origin https://github.com/usuario/proyecto.git
git push -u origin main
```

---

## Conclusión

Con estos comandos ya puedes:

- Crear repositorios
- Guardar versiones
- Subir proyectos a GitHub
- Descargar proyectos
- Trabajar con ramas

Cuando domines esto, podrás aprender temas más avanzados como **merge conflicts**, **pull requests** y **GitHub Actions**.
