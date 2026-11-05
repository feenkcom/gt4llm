Class {
	#name : #GtLRefactoringChangeExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'examples - basic' }
GtLRefactoringChangeExamples >> refactoringChange [
	<gtExample>
	<return: #GtLRefactoringChange>
	| change |
	change := GtLRefactoringChange changeDescription: 'MySuperclass>>foo'
				newSource: 'foo ^ 42'.
	self assert: change changeDescription equals: 'MySuperclass>>foo'.
	self assert: change newSource equals: 'foo ^ 42'.
	^change
]

{ #category : #'examples - views' }
GtLRefactoringChangeExamples >> refactoringChangeMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| mainDataView |
	mainDataView := self refactoringChange llmDataViewsFor: GtLDataView new.
	self
		assertCompositeDataView: mainDataView
		hasTitle: 'Object views'
		viewsCount: 1.
	self assertCompositeView: mainDataView hasMagritteDataViewWithDataKey: nil.
	^mainDataView
]

{ #category : #'examples - serialization' }
GtLRefactoringChangeExamples >> refactoringChangeSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| dataBlock expected |
	dataBlock := self refactoringChangeMainDataView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	expected := (Dictionary new)
				at: #changeDescription put: 'MySuperclass>>foo';
				at: #newSource put: 'foo ^ 42';
				yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	^dataBlock
]
