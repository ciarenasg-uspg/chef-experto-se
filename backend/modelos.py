from pydantic import BaseModel, Field
from typing import Literal

TipoDesayuno = Literal["completo", "ligero"]

class SolicitudDesayuno(BaseModel):
    tipo_desayuno: TipoDesayuno
    ingredientes: list[str] = Field(default_factory=list)

class ResultadoDesayuno(BaseModel):
    estado: str
    tipo_desayuno_solicitado: str
    tipo_desayuno_resultado: str | None = None
    ingredientes: list[str] = Field(default_factory=list)
    mensaje: str
    justificacion: str | None = None
    regla: str | None = None
    faltantes: list[str] = Field(default_factory=list)
