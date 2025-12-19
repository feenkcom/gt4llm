Extension { #name : #MAContainer }

{ #category : #'*Gt4LlmCore' }
MAContainer >> gtJsonSchemaTypeName [
	^ self properties at: 'originalClass'
]
