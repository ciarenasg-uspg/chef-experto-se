const ingredientesContainer =
    document.getElementById(
        "ingredientesContainer"
    );

const btnAnalizar =
    document.getElementById(
        "btnAnalizar"
    );

const btnLimpiar =
    document.getElementById(
        "btnLimpiar"
    );

const resultado =
    document.getElementById(
        "resultado"
    );

const resultadoContenido =
    document.getElementById(
        "resultadoContenido"
    );


const nombresCategorias = {
    bebidas: "Bebidas",
    proteinas: "Proteínas",
    carbohidratos: "Carbohidratos",
    frutas: "Frutas"
};


async function cargarIngredientes() {

    try {

        const respuesta =
            await fetch(
                "/api/v1/ingredientes"
            );

        if (!respuesta.ok) {
            throw new Error(
                "No fue posible obtener los ingredientes."
            );
        }

        const datos =
            await respuesta.json();

        ingredientesContainer.innerHTML = "";

        Object.entries(datos)
            .forEach(
                ([categoria, ingredientes]) => {

                    const bloque =
                        document.createElement(
                            "div"
                        );

                    bloque.className =
                        "categoria";

                    const titulo =
                        document.createElement(
                            "h3"
                        );

                    titulo.textContent =
                        nombresCategorias[
                            categoria
                        ];

                    bloque.appendChild(
                        titulo
                    );


                    ingredientes.forEach(
                        (ingrediente) => {

                            const label =
                                document.createElement(
                                    "label"
                                );

                            label.className =
                                "ingrediente";


                            const checkbox =
                                document.createElement(
                                    "input"
                                );

                            checkbox.type =
                                "radio";

                            checkbox.name =
                                categoria;
                                
                            checkbox.value =
                                ingrediente.id;

                            checkbox.dataset.nombre =
                                ingrediente.nombre;


                            const texto =
                                document.createElement(
                                    "span"
                                );

                            texto.textContent =
                                ingrediente.nombre;


                            label.appendChild(
                                checkbox
                            );

                            label.appendChild(
                                texto
                            );

                            bloque.appendChild(
                                label
                            );
                        }
                    );


                    ingredientesContainer.appendChild(
                        bloque
                    );
                }
            );

    } catch (error) {

        ingredientesContainer.innerHTML = `
            <p>
                Error al cargar ingredientes:
                ${error.message}
            </p>
        `;
    }
}


function obtenerTipoDesayuno() {

    const seleccionado =
        document.querySelector(
            'input[name="tipoDesayuno"]:checked'
        );

    return seleccionado
        ? seleccionado.value
        : null;
}


function obtenerIngredientes() {

    const seleccionados =
        document.querySelectorAll(
            '#ingredientesContainer input[type="radio"]:checked'
        );

    return Array.from(
        seleccionados
    ).map(
        (elemento) =>
            elemento.value
    );
}


function mostrarResultado(datos) {

    resultado.classList.remove(
        "oculto"
    );

    resultado.classList.remove(
        "ligero",
        "error"
    );


    if (
        datos.tipo_desayuno_resultado ===
        "ligero"
    ) {

        resultado.classList.add(
            "ligero"
        );
    }


    if (
        datos.estado !== "EXITO"
    ) {

        resultado.classList.add(
            "error"
        );
    }


    const titulo =
        datos.tipo_desayuno_resultado ===
        "completo"
            ? "🍳 Desayuno completo"
            : datos.tipo_desayuno_resultado ===
              "ligero"
                ? "🥪 Desayuno ligero"
                : "⚠️ Sin recomendación";


    let html = `
        <div class="resultado-titulo">
            ${titulo}
        </div>

        <p>
            ${datos.mensaje}
        </p>
    `;


    if (
        datos.ingredientes &&
        datos.ingredientes.length > 0
    ) {

        html += `
            <div class="lista-ingredientes">
        `;


        datos.ingredientes.forEach(
            (ingrediente) => {

                html += `
                    <span
                        class="ingrediente-resultado"
                    >
                        ${ingrediente}
                    </span>
                `;
            }
        );


        html += `
            </div>
        `;
    }


    if (
        datos.justificacion
    ) {

        html += `
            <div class="info">

                <strong>
                    Justificación:
                </strong>

                <p>
                    ${datos.justificacion}
                </p>

            </div>
        `;
    }


    if (
        datos.regla
    ) {

        html += `
            <div class="info">

                <strong>
                    Regla activada:
                </strong>

                <p class="regla">
                    ${datos.regla}
                </p>

            </div>
        `;
    }


    if (
        datos.faltantes &&
        datos.faltantes.length > 0
    ) {

        html += `
            <div class="info">

                <strong>
                    Falta:
                </strong>

                <p class="faltantes">
                    ${datos.faltantes.join(", ")}
                </p>

            </div>
        `;
    }


    resultadoContenido.innerHTML =
        html;


    resultado.scrollIntoView({
        behavior: "smooth"
    });
}


async function analizarDesayuno() {

    const tipoDesayuno =
        obtenerTipoDesayuno();

    const ingredientes =
        obtenerIngredientes();


    if (!tipoDesayuno) {

        alert(
            "Seleccione el tipo de desayuno."
        );

        return;
    }


    try {

        btnAnalizar.disabled =
            true;

        btnAnalizar.textContent =
            "Analizando...";


        const respuesta =
            await fetch(
                "/api/v1/recomendar",
                {
                    method: "POST",

                    headers: {
                        "Content-Type":
                            "application/json"
                    },

                    body: JSON.stringify({
                        tipo_desayuno:
                            tipoDesayuno,

                        ingredientes:
                            ingredientes
                    })
                }
            );


        const datos =
            await respuesta.json();


        if (!respuesta.ok) {

            throw new Error(
                datos.detail ||
                "Error en el servidor."
            );
        }


        mostrarResultado(
            datos
        );


    } catch (error) {

        resultado.classList.remove(
            "oculto"
        );

        resultado.classList.add(
            "error"
        );

        resultadoContenido.innerHTML = `
            <div class="resultado-titulo">
                ⚠️ Error
            </div>

            <p>
                ${error.message}
            </p>
        `;

    } finally {

        btnAnalizar.disabled =
            false;

        btnAnalizar.textContent =
            "Analizar desayuno";
    }
}


function limpiar() {

    document
        .querySelectorAll(
            '#ingredientesContainer input[type="radio"]'
        )
        .forEach(
            (checkbox) => {
                checkbox.checked = false;
            }
        );

    document
        .querySelectorAll(
            '#desayunoContainer input[type="radio"]'
        )
        .forEach(
            (checkbox) => {
                checkbox.checked = false;
            }
        );


    resultado.classList.add(
        "oculto"
    );

    resultadoContenido.innerHTML =
        "";
}


btnAnalizar.addEventListener(
    "click",
    analizarDesayuno
);

btnLimpiar.addEventListener(
    "click",
    limpiar
);


cargarIngredientes();
