Class {
	#name : #GtLTransformationProblemExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'examples - basic' }
GtLTransformationProblemExamples >> transformationProblem [
	<gtExample>
	<return: #GtLTransformationProblem>
	| problem |
	problem := GtLTransformationProblem
				description: 'Class not found: ClassThatDoesNotExist'.
	self assert: problem description
		equals: 'Class not found: ClassThatDoesNotExist'.
	^problem
]

{ #category : #'examples - views' }
GtLTransformationProblemExamples >> transformationProblemMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| mainDataView |
	mainDataView := self transformationProblem
				llmDataViewsFor: GtLDataView new.
	self
		assertCompositeDataView: mainDataView
		hasTitle: 'Object views'
		viewsCount: 1.
	self assertCompositeView: mainDataView hasMagritteDataViewWithDataKey: nil.
	^mainDataView
]

{ #category : #'examples - serialization' }
GtLTransformationProblemExamples >> transformationProblemSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| dataBlock expected |
	dataBlock := self transformationProblemMainDataView
				serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	expected := (Dictionary new)
				at: #description put: 'Class not found: ClassThatDoesNotExist';
				yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	^dataBlock
]
