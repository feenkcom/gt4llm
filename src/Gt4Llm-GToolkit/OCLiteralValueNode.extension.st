Extension { #name : #OCLiteralValueNode }

{ #category : #'*Gt4Llm-GToolkit' }
OCLiteralValueNode >> gtIsFormatComponentIn: aTutor [
	(self isString or: [ self isSymbol ]) ifFalse: [ ^ false ].
	^ (aTutor new formatNamed: self value) isNotNil
]
