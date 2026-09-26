; ============================================================
; CHEFEXPERTO
; Sistema Experto para Selección de Desayunos
; ============================================================

; ============================================================
; ONTOLOGÍA
; ============================================================



(deftemplate ingrediente
   (slot nombre)
   (slot categoria)
)

(deftemplate solicitud
   (slot tipo)
)

(deftemplate resultado
   (slot tipo)
   (multislot ingredientes)
   (slot mensaje)
   (slot justificacion)
   (slot regla)
   (multislot faltantes)
)


; ============================================================
; DESAYUNO COMPLETO
; ============================================================
(defrule desayuno-completo
   (declare (salience 100))

   (solicitud
      (tipo completo))

   (ingrediente
      (nombre ?proteina)
      (categoria proteina))

   (ingrediente
      (nombre ?bebida)
      (categoria bebida))

   (ingrediente
      (nombre ?carbohidrato)
      (categoria carbohidrato))

   (not
      (resultado))

   =>
   (assert
      (resultado
         (tipo completo)

         (ingredientes
            ?proteina
            ?bebida
            ?carbohidrato)

         (mensaje
            "Es posible preparar un desayuno completo.")

         (justificacion
            "El desayuno contiene una proteína, una bebida y un carbohidrato.")

         (regla
            "desayuno-completo")

         (faltantes)))
)



; ============================================================
; FRUTA OPCIONAL
; ============================================================

(defrule desayuno-completo-con-fruta
   (declare (salience 110))

   (solicitud
      (tipo completo))

   (ingrediente
      (nombre ?proteina)
      (categoria proteina))

   (ingrediente
      (nombre ?bebida)
      (categoria bebida))

   (ingrediente
      (nombre ?carbohidrato)
      (categoria carbohidrato))

   (ingrediente
      (nombre ?fruta)
      (categoria fruta))

   (not
      (resultado))

   =>
   (assert
      (resultado
         (tipo completo)

         (ingredientes
            ?proteina
            ?bebida
            ?carbohidrato
            ?fruta)

         (mensaje
            "Es posible preparar un desayuno completo con fruta.")

         (justificacion
            "El desayuno contiene proteína, bebida y carbohidrato. La fruta se incorpora como elemento opcional.")

         (regla
            "desayuno-completo-con-fruta")

         (faltantes)))
)


; ============================================================
; DETECTAR CATEGORIAS
; ============================================================

(defrule detectar-proteina
   (declare (salience 150))

   (ingrediente
      (categoria proteina))
   (not
      (categoria-disponible proteina))
   =>
   (assert
      (categoria-disponible proteina))
)

(defrule detectar-bebida
   (declare (salience 150))

   (ingrediente
      (categoria bebida))
   (not
      (categoria-disponible bebida))
   =>
   (assert
      (categoria-disponible bebida))
)

(defrule detectar-carbohidrato
   (declare (salience 150))

   (ingrediente
      (categoria carbohidrato))
   (not
      (categoria-disponible carbohidrato))
   =>
   (assert
      (categoria-disponible carbohidrato))
)

(defrule detectar-fruta
   (declare (salience 150))

   (ingrediente
      (categoria fruta))
   (not
      (categoria-disponible fruta))
   =>
   (assert
      (categoria-disponible fruta))
)



; ============================================================
; FALTA PROTEINA 
; ============================================================

(defrule falta-proteina
   (solicitud
      (tipo completo))

   (ingrediente
      (nombre ?bebida)
      (categoria bebida))

   (ingrediente
      (nombre ?carbohidrato)
      (categoria carbohidrato))

   (ingrediente
      (nombre ?fruta)
      (categoria fruta))

   (not
      (categoria-disponible proteina))

   (not
      (resultado))

   =>
   (assert
      (resultado
         (tipo ligero)

         (ingredientes
            ?bebida
            ?carbohidrato
            ?fruta)

         (mensaje
            "No es posible preparar un desayuno completo.")

         (justificacion
            "El desayuno completo requiere una proteína.")

         (regla
            "faltante-proteina")

         (faltantes
            proteina)))
)


(defrule falta-proteina-v
   (solicitud
      (tipo completo))

   (ingrediente
      (nombre ?bebida)
      (categoria bebida))

   (ingrediente
      (nombre ?carbohidrato)
      (categoria carbohidrato))

   (not
      (categoria-disponible proteina))

   (not
      (resultado))

   =>
   (assert
      (resultado
         (tipo ligero)

         (ingredientes
            ?bebida
            ?carbohidrato)

         (mensaje
            "No es posible preparar un desayuno completo.")

         (justificacion
            "El desayuno completo requiere una proteína.")

         (regla
            "faltante-proteina-f")

         (faltantes
            proteina)))
)




; ============================================================
; FALTA BEBIDA 
; ============================================================
(defrule falta-bebida
   (solicitud
      (tipo completo))

   (categoria-disponible proteina)

   (not
      (categoria-disponible bebida))

   (not
      (resultado))

   =>
   (assert
      (resultado
         (tipo ligero)

         (ingredientes)

         (mensaje
            "No es posible preparar un desayuno completo.")

         (justificacion
            "El desayuno completo requiere una bebida.")

         (regla
            "faltante-bebida")

         (faltantes
            bebida)))
)



; ============================================================
; FALTA CARBOHIDRATO 
; ============================================================
(defrule falta-carbohidrato
   (solicitud
      (tipo completo))

   (categoria-disponible proteina)

   (categoria-disponible bebida)

   (not
      (categoria-disponible carbohidrato))

   (not
      (resultado))

   =>
   (assert
      (resultado
         (tipo ligero)

         (ingredientes)

         (mensaje
            "No es posible preparar un desayuno completo.")

         (justificacion
            "El desayuno completo requiere un carbohidrato.")

         (regla
            "faltante-carbohidrato")

         (faltantes
            carbohidrato)))
)



; ============================================================
;necesitamos ofrecer el desayuno ligero
;Aquí definimos una política muy sencilla para el sistema.
;Cuando se necesita un desayuno ligero:
;Prioridad
;Proteína + carbohidrato
;Bebida + carbohidrato
;Proteína + fruta
;Bebida + fruta
;Carbohidrato + fruta
;Proteína + bebida
;Un solo ingrediente
;Esto nos permite tener resultados consistentes.
; ============================================================



; ============================================================
; LIGERO: PROTEINA + CARBOHIDRATO
; ============================================================
(defrule ligero-proteina-carbohidrato
   (declare (salience 80))

   (solicitud
      (tipo ligero))

   (categoria-disponible proteina)
   (categoria-disponible carbohidrato)

   (not
      (resultado))

   (ingrediente
      (nombre ?proteina)
      (categoria proteina))

   (ingrediente
      (nombre ?carbohidrato)
      (categoria carbohidrato))

   =>
   (assert
      (resultado
         (tipo ligero)

         (ingredientes
            ?proteina
            ?carbohidrato)

         (mensaje
            "Se recomienda un desayuno ligero de proteína y carbohidrato.")

         (justificacion
            "Se seleccionó una combinación de proteína y carbohidrato disponible.")

         (regla
            "ligero-proteina-carbohidrato")

         (faltantes)))
)





; ============================================================
; LIGERO: BEBIDA + CARBOHIDRATO
; ============================================================
(defrule ligero-bebida-carbohidrato
   (declare (salience 70))

   (solicitud
      (tipo ligero))

   (categoria-disponible bebida)
   (categoria-disponible carbohidrato)

   (not
      (resultado))

   (ingrediente
      (nombre ?bebida)
      (categoria bebida))

   (ingrediente
      (nombre ?carbohidrato)
      (categoria carbohidrato))

   =>
   (assert
      (resultado
         (tipo ligero)

         (ingredientes
            ?bebida
            ?carbohidrato)

         (mensaje
            "Se recomienda un desayuno ligero de bebida y carbohidrato.")

         (justificacion
            "Se seleccionó una combinación de bebida y carbohidrato disponible.")

         (regla
            "ligero-bebida-carbohidrato")

         (faltantes)))
)



; ============================================================
; LIGERO: PROTEINA + FRUTA
; ============================================================
(defrule ligero-proteina-fruta
   (declare (salience 60))

   (solicitud
      (tipo ligero))

   (categoria-disponible proteina)
   (categoria-disponible fruta)

   (not
      (resultado))

   (ingrediente
      (nombre ?proteina)
      (categoria proteina))

   (ingrediente
      (nombre ?fruta)
      (categoria fruta))

   =>
   (assert
      (resultado
         (tipo ligero)

         (ingredientes
            ?proteina
            ?fruta)

         (mensaje
            "Se recomienda un desayuno ligero de proteína y fruta.")

         (justificacion
            "Se seleccionó una combinación de proteína y fruta disponible.")

         (regla
            "ligero-proteina-fruta")

         (faltantes)))
)



; ============================================================
; LIGERO: BEBIDA + FRUTA
; ============================================================
(defrule ligero-bebida-fruta
   (declare (salience 50))

   (solicitud
      (tipo ligero))

   (categoria-disponible bebida)
   (categoria-disponible fruta)

   (not
      (resultado))

   (ingrediente
      (nombre ?bebida)
      (categoria bebida))

   (ingrediente
      (nombre ?fruta)
      (categoria fruta))

   =>
   (assert
      (resultado
         (tipo ligero)

         (ingredientes
            ?bebida
            ?fruta)

         (mensaje
            "Se recomienda un desayuno ligero de bebida y fruta.")

         (justificacion
            "Se seleccionó una combinación de bebida y fruta disponible.")

         (regla
            "ligero-bebida-fruta")

         (faltantes)))
)



; ============================================================
; LIGERO: CARBOHIDRATO + FRUTA
; ============================================================
(defrule ligero-carbohidrato-fruta
   (declare (salience 40))

   (solicitud
      (tipo ligero))

   (categoria-disponible carbohidrato)
   (categoria-disponible fruta)

   (not
      (resultado))

   (ingrediente
      (nombre ?carbohidrato)
      (categoria carbohidrato))

   (ingrediente
      (nombre ?fruta)
      (categoria fruta))

   =>
   (assert
      (resultado
         (tipo ligero)

         (ingredientes
            ?carbohidrato
            ?fruta)

         (mensaje
            "Se recomienda un desayuno ligero de carbohidrato y fruta.")

         (justificacion
            "Se seleccionó una combinación de carbohidrato y fruta disponible.")

         (regla
            "ligero-carbohidrato-fruta")

         (faltantes)))
)




; ============================================================
; LIGERO: PROTEINA + BEBIDA
; ============================================================
(defrule ligero-proteina-bebida
   (declare (salience 30))

   (solicitud
      (tipo ligero))

   (categoria-disponible proteina)
   (categoria-disponible bebida)

   (not
      (resultado))

   (ingrediente
      (nombre ?proteina)
      (categoria proteina))

   (ingrediente
      (nombre ?bebida)
      (categoria bebida))

   =>
   (assert
      (resultado
         (tipo ligero)

         (ingredientes
            ?proteina
            ?bebida)

         (mensaje
            "Se recomienda un desayuno ligero de proteína y bebida.")

         (justificacion
            "Se seleccionó una combinación de proteína y bebida disponible.")

         (regla
            "ligero-proteina-bebida")

         (faltantes)))
)




; ============================================================
; UN SOLO INGREDIENTE
; ============================================================
(defrule ligero-un-ingrediente
   (declare (salience 10))

   (solicitud
      (tipo ligero))

   (ingrediente
      (nombre ?ingrediente)
      (categoria ?categoria))

   (not
         (resultado))

   =>
   (assert
      (resultado
         (tipo ligero)

         (ingredientes
            ?ingrediente)

         (mensaje
            "Solo es posible recomendar un desayuno ligero con un ingrediente.")

         (justificacion
            "No existen suficientes categorías de ingredientes para formar una combinación de dos elementos.")

         (regla
            "ligero-un-ingrediente")

         (faltantes)))
)



; ============================================================
; SIN INGREDIENTES
; ============================================================
(defrule sin-ingredientes
   (declare (salience 200))

   (solicitud
      (tipo ?tipo))

   (not
      (ingrediente))

   (not
      (resultado))

   =>
   (assert
      (resultado
         (tipo ninguno)

         (ingredientes)

         (mensaje
            "No es posible recomendar un desayuno.")

         (justificacion
            "No se proporcionaron ingredientes disponibles.")

         (regla
            "sin-ingredientes")

         (faltantes
            ingrediente)))
)
