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
; semana10 reglas
; ============================================================
(defrule sin-ingredientes
   (declare (salience 200))
   (solicitud (tipo ?tipo))
   (not (ingrediente))
   (not (resultado))
   =>
   (assert
      (resultado
         (tipo ninguno)
         (ingredientes)
         (mensaje "No es posible recomendar un desayuno.")
         (justificacion "No se proporcionaron ingredientes disponibles.")
         (regla "sin-ingredientes")
         (faltantes ingrediente)
      )
   )
)

(defrule ligero-proteina-carbohidrato
   (declare (salience 80))
   (solicitud (tipo ligero))
   (ingrediente (nombre ?proteina) (categoria proteina))
   (ingrediente (nombre ?carbohidrato) (categoria carbohidrato))
   (not (resultado))
   =>
   (assert
      (resultado
         (tipo ligero)
         (ingredientes ?proteina ?carbohidrato)
         (mensaje "Se recomienda un desayuno ligero de proteína y carbohidrato.")
         (justificacion "Se seleccionó una combinación de proteína y carbohidrato disponible.")
         (regla "ligero-proteina-carbohidrato")
         (faltantes)
      )
   )
)

(defrule ligero-un-ingrediente
   (declare (salience 10))
   (solicitud (tipo ligero))
   (ingrediente (nombre ?ingrediente) (categoria ?categoria))
   (not (resultado))
   =>
   (assert
      (resultado
         (tipo ligero)
         (ingredientes ?ingrediente)
         (mensaje "Solo es posible recomendar un desayuno ligero con un ingrediente.")
         (justificacion "No existen suficientes categorías para formar una combinación.")
         (regla "ligero-un-ingrediente")
         (faltantes)
      )
   )
)

; ============================================================
; semana 10 reglas end
; ============================================================