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