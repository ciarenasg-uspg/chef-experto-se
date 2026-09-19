from pathlib import Path
import clips

class MotorChefExperto:
    INGREDIENTES_VALIDOS = {
        "cafe": "bebida",
        "te": "bebida",
        "huevo": "proteina",
        "queso": "proteina",
        "pan": "carbohidrato",
        "tortilla": "carbohidrato",
        "banano": "fruta",
        "manzana": "fruta",
    }

    NOMBRES = {
        "cafe": "Café",
        "te": "Té",
        "huevo": "Huevo",
        "queso": "Queso",
        "pan": "Pan",
        "tortilla": "Tortilla",
        "banano": "Banano",
        "manzana": "Manzana",
    }

    def __init__(self):
        self.ruta_clp = Path(__file__).resolve().parent / "conocimiento.clp"

    def normalizar_ingredientes(self, ingredientes: list[str]) -> list[str]:
        resultado = []
        for ingrediente in ingredientes:
            nombre = (ingrediente.strip().lower()
                      .replace("á", "a").replace("é", "e")
                      .replace("í", "i").replace("ó", "o")
                      .replace("ú", "u"))
            if nombre in self.INGREDIENTES_VALIDOS and nombre not in resultado:
                resultado.append(nombre)
        return resultado

    def inferir(self, tipo_desayuno: str, ingredientes: list[str]) -> dict:
        ingredientes = self.normalizar_ingredientes(ingredientes)

        env = clips.Environment()
        env.load(str(self.ruta_clp))

        solicitud_template = env.find_template("solicitud")
        solicitud_template.assert_fact(tipo=clips.Symbol(tipo_desayuno))

        ingrediente_template = env.find_template("ingrediente")
        for nombre in ingredientes:
            ingrediente_template.assert_fact(
                nombre=clips.Symbol(nombre),
                categoria=clips.Symbol(self.INGREDIENTES_VALIDOS[nombre])
            )

        env.run()

        resultado_template = env.find_template("resultado")
        resultados = list(resultado_template.facts())

        if not resultados:
            return {
                "estado": "SIN_INFERENCIA",
                "tipo_desayuno_solicitado": tipo_desayuno,
                "tipo_desayuno_resultado": None,
                "ingredientes": [],
                "mensaje": "No fue posible obtener una inferencia.",
                "justificacion": None,
                "regla": None,
                "faltantes": [],
            }

        fact = resultados[0]
        return {
            "estado": "EXITO",
            "tipo_desayuno_solicitado": tipo_desayuno,
            "tipo_desayuno_resultado": str(fact["tipo"]),
            "ingredientes": [self.NOMBRES.get(str(x), str(x)) for x in fact["ingredientes"]],
            "mensaje": str(fact["mensaje"]),
            "justificacion": str(fact["justificacion"]),
            "regla": str(fact["regla"]),
            "faltantes": [str(x) for x in fact["faltantes"]],
        }
