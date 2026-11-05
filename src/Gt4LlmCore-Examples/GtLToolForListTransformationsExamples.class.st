Class {
	#name : #GtLToolForListTransformationsExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLToolForListTransformationsExamples >> gtToolsIncludeRefactoringTools [
	<gtExample>
	| names |
	names := (GtLTools gt collect: [:each | each name]) asSet.
	self assert: (names
				includesAll: #('listTransformations' 'previewRefactoring' 'applyRefactoring' 'previewRewrite')).
	^names
]

{ #category : #examples }
GtLToolForListTransformationsExamples >> listTransformations [
	<gtExample>
	| call targetObject |
	call := self executeTool: GtLToolForListTransformations new
				withArguments: Dictionary new.
	targetObject := call result targetObject.
	self assert: targetObject class equals: GtLTransformationsSchema.
	self assert: (self transformationNamesIn: targetObject schema)
		equals: #('AddClass' 'AddMethod' 'PushUpInstanceVariable' 'PushUpMethod' 'RemoveMethod')
				asSet.
	self assert: ((self transformationNamesIn: targetObject schema)
				includes: 'PushUpInstanceVariable').
	^call
]

{ #category : #examples }
GtLToolForListTransformationsExamples >> listTransformationsSchemaEntries [
	<gtExample>
	| targetObject entries |
	targetObject := (self executeTool: GtLToolForListTransformations new
				withArguments: Dictionary new) result
				targetObject.
	entries := targetObject transformationSchemas.
	self
		assert: (entries
				collect: [:each | targetObject nameOfTransformationSchema: each]) asSet
		equals: #('AddClass' 'AddMethod' 'PushUpInstanceVariable' 'PushUpMethod' 'RemoveMethod')
				asSet.
	self assert: (entries
				allSatisfy: [:each | (targetObject descriptionOfTransformationSchema: each) notEmpty]).
	^targetObject
]

{ #category : #helpers }
GtLToolForListTransformationsExamples >> transformationNamesIn: aSchema [
	^(((((aSchema at: 'properties') at: 'transformations') at: 'items')
		at: 'anyOf') collect: [:each | (each at: 'required') first])
		asSet
]
