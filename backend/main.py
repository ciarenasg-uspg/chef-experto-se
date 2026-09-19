from fastapi import FastAPI
from .modelos import SolicitudDesayuno, ResultadoDesayuno
from .motor_experto import MotorChefExperto

app = FastAPI(
    title="ChefExperto API",
    description="API REST para exponer el motor experto CLIPS mediante Python.",
    version="1.0.0",
)

motor = MotorChefExperto()

@app.get("/api/v1/health")
def health():
    return {
        "estado": "OK",
        "sistema": "ChefExperto",
        "motor": "CLIPS",
        "integracion": "clipspy",
    }

@app.get("/api/v1/ingredientes")
def obtener_ingredientes():
    return {
        "bebidas": [
            {"id": "cafe", "nombre": "Café"},
            {"id": "te", "nombre": "Té"},
        ],
        "proteinas": [
            {"id": "huevo", "nombre": "Huevo"},
            {"id": "queso", "nombre": "Queso"},
        ],
        "carbohidratos": [
            {"id": "pan", "nombre": "Pan"},
            {"id": "tortilla", "nombre": "Tortilla"},
        ],
        "frutas": [
            {"id": "banano", "nombre": "Banano"},
            {"id": "manzana", "nombre": "Manzana"},
        ],
    }

@app.post("/api/v1/recomendar", response_model=ResultadoDesayuno)
def recomendar(solicitud: SolicitudDesayuno):
    return motor.inferir(
        tipo_desayuno=solicitud.tipo_desayuno,
        ingredientes=solicitud.ingredientes,
    )
