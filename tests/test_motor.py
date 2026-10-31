import pytest

from backend.motor_experto import (
    MotorChefExperto,
)


@pytest.fixture
def motor():
    return MotorChefExperto()


def test_desayuno_completo(
    motor
):

    resultado = motor.inferir(
        "completo",
        [
            "huevo",
            "cafe",
            "pan",
        ],
    )

    assert resultado["estado"] == "EXITO"

    assert (
        resultado[
            "tipo_desayuno_resultado"
        ]
        == "completo"
    )

    assert (
        resultado["regla"]
        == "desayuno-completo"
    )


def test_desayuno_completo_con_fruta(
    motor
):

    resultado = motor.inferir(
        "completo",
        [
            "huevo",
            "cafe",
            "pan",
            "banano",
        ],
    )

    assert resultado["estado"] == "EXITO"

    assert (
        resultado[
            "tipo_desayuno_resultado"
        ]
        == "completo"
    )

    assert "Banano" in resultado[
        "ingredientes"
    ]


def test_falta_proteina(
    motor
):

    resultado = motor.inferir(
        "completo",
        [
            "cafe",
            "pan",
        ],
    )

    assert (
        resultado[
            "tipo_desayuno_resultado"
        ]
        == "ligero"
    )

    assert "proteina" in resultado[
        "faltantes"
    ]


def test_falta_bebida(
    motor
):

    resultado = motor.inferir(
        "completo",
        [
            "huevo",
            "pan",
        ],
    )

    assert (
        resultado[
            "tipo_desayuno_resultado"
        ]
        == "ligero"
    )

    assert "bebida" in resultado[
        "faltantes"
    ]


def test_falta_carbohidrato(
    motor
):

    resultado = motor.inferir(
        "completo",
        [
            "huevo",
            "cafe",
        ],
    )

    assert (
        resultado[
            "tipo_desayuno_resultado"
        ]
        == "ligero"
    )

    assert "carbohidrato" in resultado[
        "faltantes"
    ]


def test_ligero_proteina_carbohidrato(
    motor
):

    resultado = motor.inferir(
        "ligero",
        [
            "huevo",
            "pan",
        ],
    )

    assert (
        resultado[
            "tipo_desayuno_resultado"
        ]
        == "ligero"
    )

    assert (
        resultado["regla"]
        == "ligero-proteina-carbohidrato"
    )


def test_ligero_bebida_carbohidrato(
    motor
):

    resultado = motor.inferir(
        "ligero",
        [
            "cafe",
            "pan",
        ],
    )

    assert (
        resultado["regla"]
        == "ligero-bebida-carbohidrato"
    )


def test_ligero_proteina_fruta(
    motor
):

    resultado = motor.inferir(
        "ligero",
        [
            "huevo",
            "banano",
        ],
    )

    assert (
        resultado["regla"]
        == "ligero-proteina-fruta"
    )


def test_ligero_bebida_fruta(
    motor
):

    resultado = motor.inferir(
        "ligero",
        [
            "cafe",
            "banano",
        ],
    )

    assert (
        resultado["regla"]
        == "ligero-bebida-fruta"
    )


def test_ligero_carbohidrato_fruta(
    motor
):

    resultado = motor.inferir(
        "ligero",
        [
            "pan",
            "banano",
        ],
    )

    assert (
        resultado["regla"]
        == "ligero-carbohidrato-fruta"
    )


def test_ligero_proteina_bebida(
    motor
):

    resultado = motor.inferir(
        "ligero",
        [
            "huevo",
            "cafe",
        ],
    )

    assert (
        resultado["regla"]
        == "ligero-proteina-bebida"
    )


def test_un_solo_ingrediente(
    motor
):

    resultado = motor.inferir(
        "ligero",
        [
            "banano",
        ],
    )

    assert (
        resultado["regla"]
        == "ligero-un-ingrediente"
    )


def test_sin_ingredientes(
    motor
):

    resultado = motor.inferir(
        "completo",
        [],
    )

    assert (
        resultado[
            "tipo_desayuno_resultado"
        ]
        == "ninguno"
    )


def test_ingredientes_invalidos(
    motor
):

    resultado = motor.inferir(
        "completo",
        [
            "pizza",
            "hamburguesa",
        ],
    )

    assert (
        resultado[
            "tipo_desayuno_resultado"
        ]
        == "ninguno"
    )
