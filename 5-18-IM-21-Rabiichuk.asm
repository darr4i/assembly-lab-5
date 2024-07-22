.386
.model flat, stdcall
option casemap: none

include \masm32\include\masm32rt.inc

.data?
  myResultOfCalculation dd 5 dup(?)
  firstPartOfFormula dd 1 dup(?)
  secondPartOfFormula dd 1 dup(?)
  myMessageLab5 db 512 dup(?)

displayMessage macro windowMessage, windowTitle 
  invoke MessageBox, 0, offset windowMessage, offset windowTitle, 0
endm

.data 
  labTitle db "Laboratorna 5 Rabiichuk Daria", 0
  myMessageNormalText db "(2*%i - 38*%i)/(%i+ %i/%i + 1) = %i", 10,
                "Final result = %i", 10,
                "a = %i, b = %i, c = %i", 10, 10, 0
  myMessageErrorText db "(2*%i - 38*%i)/(%i+ %i/%i + 1) = ERROR", 10,
                "Final result = ERROR", 10,
                "a = %i, b = %i, c = %i", 10, 10, 
                "you have divison by 0, try again", 10, 10, 0
               
  arrayForCalculationA dd 20, 6, -4, -20, 30, 3
  arrayForCalculationB dd 15, 3, 8, 10, 10, -2
  arrayForCalculationC dd 5, 2, 4, 4, -3, 3

.code
laba5Rabiichuk:
  mov esi, 0
  .while esi < 6

    ;; secondPartOfFormula calculation
    mov eax, arrayForCalculationB[esi * 4]       ; Завантажуємо значення b з масиву arrayB в eax
    mov eax, arrayForCalculationA[esi * 4]       ; Додаємо значення a з масиву arrayA до eax
    cdq                                         ; Розширюємо eax до edx:eax для ділення
    idiv dword ptr arrayForCalculationC[esi * 4] ; Ділимо edx:eax на значення c з масиву arrayC
    add eax, 1                                  ; Додаємо 1 до eax (результат a/c + 1)
    add eax, arrayForCalculationB[esi * 4]       ; Додаємо значення b знову (b + a/c + 1)

    mov secondPartOfFormula, eax           ; Зберігаємо результат у змінній denominator

    division_by_zero:
    
    .if secondPartOfFormula == 0
      invoke wsprintf, addr myMessageLab5, addr myMessageErrorText, 
        arrayForCalculationB[esi * 4], arrayForCalculationC[esi * 4], arrayForCalculationB[esi * 4], arrayForCalculationA[esi * 4], arrayForCalculationC[esi * 4],
        arrayForCalculationA[esi * 4], arrayForCalculationB[esi * 4], arrayForCalculationC[esi * 4]

      displayMessage myMessageLab5, labTitle

.else

    ;; firstPartOfFormula
    mov eax, 2
    imul eax, arrayForCalculationB[esi * 4] ;; 2*b

    mov edx, 38
    imul edx, arrayForCalculationC[esi * 4] ;; 38*c
    sub eax, edx ;; 2*b - 38*c

    mov firstPartOfFormula, eax

    ;; final calculation
    mov eax, firstPartOfFormula
    mov ecx, secondPartOfFormula
    cdq
    idiv ecx ;; (2*b - 38*c)/(b + a/c + 1)

    mov myResultOfCalculation, eax

    ;; check if result is pair or unpair
    test eax, 1
    jnz myUnpairedNumber
    jz myPairedNumber

    myUnpairedNumber:
      imul eax, 5 ;; result * 5
      jmp message

    myPairedNumber:
      mov ecx, 2
      cdq
      idiv ecx ;; result / 2
      jmp message

      mov myMessageLab5, 0h
      inc esi
      jmp next_iteration

    message: 
      invoke wsprintf, addr myMessageLab5, addr myMessageNormalText, 
        arrayForCalculationB[esi * 4], arrayForCalculationC[esi * 4], arrayForCalculationB[esi * 4], arrayForCalculationA[esi * 4], arrayForCalculationC[esi * 4],
        myResultOfCalculation, eax,
        arrayForCalculationA[esi * 4], arrayForCalculationB[esi * 4], arrayForCalculationC[esi * 4]

      displayMessage myMessageLab5, labTitle
      .endif

    next_iteration:
      mov myMessageLab5, 0h
      inc esi
     
  .endw

end laba5Rabiichuk
