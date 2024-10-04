Extension { #name : #GtPharoLiteralNode }

{ #category : #'*Gt4Llm' }
GtPharoLiteralNode >> gtIsFormatComponentIn: aTutor [
	(self isString or: [ self isSymbol ]) ifFalse: [ ^ false ].
	^ (aTutor new formatComponentNamed: self literalValue) isNotNil
]
