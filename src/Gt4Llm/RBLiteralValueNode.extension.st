Extension { #name : #RBLiteralValueNode }

{ #category : #'*Gt4Llm' }
RBLiteralValueNode >> gtIsFormatComponentIn: aTutor [
	(self isString or: [ self isSymbol ]) ifFalse: [ ^ false ].
	^ (aTutor new formatNamed: self value) isNotNil
]
