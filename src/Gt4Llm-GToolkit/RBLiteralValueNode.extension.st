Extension { #name : #RBLiteralValueNode }

{ #category : #'*Gt4Llm-GToolkit' }
RBLiteralValueNode >> gtIsFormatComponentIn: aTutor [
	(self isString or: [ self isSymbol ]) ifFalse: [ ^ false ].
	^ (aTutor new formatNamed: self value) isNotNil
]
