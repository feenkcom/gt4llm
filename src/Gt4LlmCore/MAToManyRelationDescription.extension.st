Extension { #name : #MAToManyRelationDescription }

{ #category : #'*Gt4LlmCore' }
MAToManyRelationDescription >> gtJsonSchemaTypeName [
	^ #ArrayOf, (String streamContents: [ :s | 
		(self classes collect: [ :each | each name] )
			 asStringOn: s 
			 delimiter: 'Or' ] )
]
