from pathlib import Path

from fastapi import FastAPI, HTTPException
from fastapi.staticfiles import StaticFiles
from .modelos import SolicitudDesayuno, ResultadoDesayuno
from .motor_experto import MotorChefExperto

BASE_DIR = Path(__file__).resolve().parent.parent
FRONTEND_DIR = BASE_DIR / "frontend"



app = FastAPI(
    title="ChefExperto API",
    description=(
        "Sistema experto para seleccionar "
        "desayunos mediante CLIPS y clipspy."
    ),
    version="1.0.0",
)


motor = MotorChefExperto()


@app.get(
    "/api/v1/ingredientes",
    tags=["Información"]
)
def obtener_ingredientes():

    return {
        "bebidas": [
            {
                "id": "cafe",
                "nombre": "Café",
            },
            {
                "id": "te",
                "nombre": "Té",
            },
        ],

        "proteinas": [
            {
                "id": "huevo",
                "nombre": "Huevo",
            },
            {
                "id": "queso",
                "nombre": "Queso",
            },
        ],

        "carbohidratos": [
            {
                "id": "pan",
                "nombre": "Pan",
            },
            {
                "id": "tortilla",
                "nombre": "Tortilla",
            },
        ],

        "frutas": [
            {
                "id": "banano",
                "nombre": "Banano",
            },
            {
                "id": "manzana",
                "nombre": "Manzana",
            },
        ],
    }


@app.post(
    "/api/v1/recomendar",
    response_model=ResultadoDesayuno,
    tags=["Inferencia"]
)
def recomendar(
    solicitud: SolicitudDesayuno
):

    resultado = motor.inferir(
        tipo_desayuno=solicitud.tipo_desayuno,
        ingredientes=solicitud.ingredientes,
    )

    if resultado["estado"] == "SIN_INFERENCIA":
        raise HTTPException(
            status_code=422,
            detail=resultado["mensaje"]
        )

    return resultado


@app.get(
    "/api/v1/health",
    tags=["Sistema"]
)
def health():

    return {
        "estado": "OK",
        "sistema": "ChefExperto",
        "motor": "CLIPS",
        "integracion": "clipspy",
    }



# ---------------------------------------------------------
# FRONTEND
# ---------------------------------------------------------

app.mount(
    "/",
    StaticFiles(
        directory=FRONTEND_DIR,
        html=True,
    ),
    name="frontend",
)