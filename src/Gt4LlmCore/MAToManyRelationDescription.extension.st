Extension { #name : #MAToManyRelationDescription }

{ #category : #'*Gt4LlmCore' }
MAToManyRelationDescription >> gtJsonSchemaTypeName [
	^ #ArrayOf, (String streamContents: [ :s | 
		(self classes collect: [ :each | each name] )
			 asStringOn: s 
			 delimiter: 'Or' ] )
]

{ #category : #'*Gt4LlmCore' }
MAToManyRelationDescription >> shouldUseExplicitContainerForChildren [
	^ self hasProperty: 'useExplicitContainerForChildren'
]

{ #category : #'*Gt4LlmCore' }
MAToManyRelationDescription >> useExplicitContainerForChildren [
	self propertyAt: 'useExplicitContainerForChildren' put: true
]
