Extension { #name : #MANumberDescription }

{ #category : #'*Gt4LlmCore' }
MANumberDescription >> beIntegerInJsonSchema [
	"Accept only integers, also in the JSON schema made from the description"

	self beInteger.
	self propertyAt: #isIntegerInJsonSchema put: true
]

{ #category : #'*Gt4LlmCore' }
MANumberDescription >> isIntegerInJsonSchema [
	^ self propertyAt: #isIntegerInJsonSchema ifAbsent: [ false ]
]
