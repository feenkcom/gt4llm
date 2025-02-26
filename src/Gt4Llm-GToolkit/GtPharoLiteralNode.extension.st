Extension { #name : #GtPharoLiteralNode }

{ #category : #'*Gt4Llm-GToolkit' }
GtPharoLiteralNode >> gtIsFormatComponentIn: aTutor [
	(self isString or: [ self isSymbol ]) ifFalse: [ ^ false ].
	^ (aTutor new formatNamed: self literalValue) isNotNil
]
