Class {
	#name : #GtLToolForListTransformations,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #Gt4LlmCore
}

{ #category : #accessing }
GtLToolForListTransformations >> description [
	^'Returns the JSON schema of the refactoring transformations accepted by previewRefactoring, under transformationsSchema. Takes no arguments. Build the transformations array following this schema and pass it to previewRefactoring.'
]

{ #category : #accessing }
GtLToolForListTransformations >> name [
	^'listTransformations'
]

{ #category : #execution }
GtLToolForListTransformations >> privatePerformToolCall: aToolCall inContext: anExecutionContext [
	^GtLTransformationsSchema new
		schema: ((GtLResponseMagritteFormat new)
				name: 'Parameters';
				modelClass: self transformationsClass) computeSchemaWithAllRequired
				json
]

{ #category : #accessing }
GtLToolForListTransformations >> transformationsClass [
	^GtLCodeTransformations
]
