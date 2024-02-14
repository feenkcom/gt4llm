Class {
	#name : #Gt4OpenAITraceStyler,
	#superclass : #GtTraceStyler,
	#category : #'Gt4OpenAI-Models'
}

{ #category : #accessing }
Gt4OpenAITraceStyler >> privateStyle: aText [
	| aString aParser |
	aString := aText asString.

	(aString beginsWith: GtLlmCheckerError prefix) ifFalse: [ ^ aText ].

	aText foreground: Color lightGray.

	(aText from: 1 to: GtLlmCheckerError prefix size)
		foreground: Color black;
		highlight: BrGlamorousColors paleErrorBackgroundColor.

	aParser := (#startOfLine asPParser / ' in ' asPParser , self classParser
			, '>>' asPParser , #endOfLine asPParser negate plus token)
			==> [ :tokens | 
				| aCompiledMethod |
				[ | aClass |
				aClass := tokens second third
						ifNil: [ tokens second first value asClass ]
						ifNotNil: [ tokens second third second value asClass ].
				aClass := tokens second second ifNil: [ aClass ] ifNotNil: [ aClass class ].
				aCompiledMethod := aClass >> tokens fourth value asSymbol.
				(aText from: tokens second first start to: tokens fourth stop)
					foreground: Color black;
					attribute: (BrGlamorousTriangleExpanderTextAttribute new
							attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
									beAppend;
									stencil: [ | editorElement coder |
										coder := GtPharoMethodCoder forMethod: aCompiledMethod.
										coder subscribeToSystem.
										editorElement := (coder asCoderViewModel expanded: true) asElement.
										editorElement border: (BlBorder paint: Color veryLightGray width: 1).
										editorElement
											margin: (BlInsets
													top: 3
													right: 10
													bottom: 10
													left: 10) ] ]) ] on: Error do: [ :e |  ] ].
	aParser sea star optimize parse: aString.
	^ aText
]

{ #category : #accessing }
Gt4OpenAITraceStyler >> style: aBlText [
	<return: #BlText>
	^ BlTextStylerTelemetry
		rootTimeSync: [ Processor activeProcess name , '  ' , self class name , ': '
				, (aBlText first: (20 min: aBlText size)) asString ]
		during: [ | aStyledText |
			aStyledText := self privateStyle: aBlText characters.
			aStyledText text ]
]
