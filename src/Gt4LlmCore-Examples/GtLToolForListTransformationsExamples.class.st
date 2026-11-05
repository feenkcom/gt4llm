Class {
	#name : #GtLToolForListTransformationsExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#category : #'Gt4LlmCore-Examples'
}

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

{ #category : #helpers }
GtLToolForListTransformationsExamples >> transformationNamesIn: aSchema [
	^(((((aSchema at: 'properties') at: 'transformations') at: 'items')
		at: 'anyOf') collect: [:each | (each at: 'required') first])
		asSet
]
