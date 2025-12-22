Extension { #name : #MAToOneRelationDescription }

{ #category : #'*Gt4LlmCore' }
MAToOneRelationDescription >> gtJsonSchemaTypeName [
	^ self classes size > 1 
		ifTrue: [ String streamContents: [ :s | 
			(self classes collect: [ :each | each name ] )
					asStringOn: s 
					delimiter: 'Or' ] ]
		ifFalse: [ self classes first ] .
]
