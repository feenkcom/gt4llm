Class {
	#name : #GtLToolForListTransformations,
	#superclass : #GtLAbstractMagritteFunctionTool,
	#category : #'Gt4LlmCore-Tools'
}

{ #category : #'gt - extensions' }
GtLToolForListTransformations class >> gtTransformationsFor: aView [
	<gtClassView>
	^ aView forward
		title: 'Transformations';
		priority: 22;
		object: [ self new ];
		view: #gtTransformationsFor:
]

{ #category : #accessing }
GtLToolForListTransformations >> description [
	^'Returns the JSON schema of the refactoring transformations accepted by previewRefactoring, under transformationsSchema. Takes no arguments. Build the transformations array following this schema and pass it to previewRefactoring.'
]

{ #category : #'gt - extensions' }
GtLToolForListTransformations >> gtTransformationsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Transformations';
		priority: 10;
		items: [ self transformationsClass new allowedTransformationClasses
				asSortedCollection: [ :a :b | a jsonSchemaLabel < b jsonSchemaLabel ] ];
		column: 'Name' text: [ :aClass | aClass jsonSchemaLabel ];
		column: 'Class' text: [ :aClass | aClass name ]
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
				modelClass: self transformationsClass) computeSchema
				json
]

{ #category : #accessing }
GtLToolForListTransformations >> transformationsClass [
	^GtLCodeTransformations
]
