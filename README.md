# ChefExperto

Sistema experto para selección de desayunos.

## Tecnologías

- Python
- CLIPS
- clipspy
- FastAPI
- HTML
- CSS
- JavaScript
- pytest

## Descripción

ChefExperto analiza el tipo de desayuno solicitado por el usuario
y los ingredientes disponibles.

Un desayuno completo requiere:

- proteína
- bebida
- carbohidrato

La fruta es opcional.

Si no es posible preparar un desayuno completo,
el sistema recomienda una combinación de desayuno ligero.

## Ingredientes

### Bebidas

- Café
- Té

### Proteínas

- Huevo
- Queso

### Carbohidratos

- Pan
- Tortilla

### Frutas

- Banano
- Manzana

## Instalación

Crear entorno virtual:

```bash
python -m venv .venv

pip install -r backend/requirements.txt
