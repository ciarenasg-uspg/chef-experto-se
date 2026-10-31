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
python -m venv .venv
pip install -r backend/requirements.txt



# CHEFEXPERTO - Backend Semana 10
## Estructura
backend/
  __init__.py
  main.py
  modelos.py
  motor_experto.py
  conocimiento.clp
  requirements.txt

## Ejecutar
Desde la carpeta que contiene `backend`:
uvicorn backend.main:app --reload

## Probar sin frontend
Abrir:
http://127.0.0.1:8000/docs

En Swagger:
POST /api/v1/recomendar

Ejemplo:
{
  "tipo_desayuno": "completo",
  "ingredientes": ["huevo", "cafe", "pan"]
}

También:
GET /api/v1/health
GET /api/v1/ingredientes

## Idea central
FastAPI recibe JSON -> Python prepara hechos -> clipspy ejecuta CLIPS -> CLIPS aplica reglas -> Python devuelve JSON.


# CHEFEXPERTO - Frontend
## Estructura

frontend/
  app.js
  index.html
  style.css


Ejecución de pruebas

El proyecto utiliza pytest para ejecutar pruebas automatizadas y verificar el funcionamiento del motor experto.

1. Instalar las dependencias

Desde la raíz del proyecto, ejecutar:

pip install -r requirements.txt

Asegúrate de que pytest esté instalado en el entorno de Python que utilizarás.

2. Ejecutar las pruebas

Desde la raíz del proyecto (breakfast-se), ejecutar:

python -m pytest -v

Este comando permite:

Descubrir y ejecutar las pruebas ubicadas en la carpeta tests/.

Mostrar el resultado de cada prueba.

Identificar cuáles pruebas finalizaron correctamente (PASSED) y cuáles fallaron (FAILED).