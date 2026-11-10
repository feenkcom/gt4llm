Class {
	#name : #GtLAppliedRefactoringExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'examples - basic' }
GtLAppliedRefactoringExamples >> appliedRefactoring [
	<gtExample>
	<return: #GtLAppliedRefactoring>
	| specification transformations preview appliedRefactoring |
	specification := (GtLAddMethodSpecification new)
				methodClassName: 'GtLAppliedRefactoringExamples';
				protocolName: 'examples';
				sourceCode: 'appliedMethod ^ 42';
				yourself.
	transformations := GtLCodeTransformations new
				transformations: (Array with: specification).
	preview := (GtLRefactoringPreview
				namespace: transformations applyRefactoring)
				objectId: 'example-object-id';
				yourself.
	appliedRefactoring := GtLAppliedRefactoring preview: preview.
	self assert: appliedRefactoring preview == preview.
	self assert: appliedRefactoring status equals: 'applied'.
	self assert: appliedRefactoring changesCount equals: 1.
	self assert: (self class includesSelector: #appliedMethod) not.
	^appliedRefactoring
]

{ #category : #'examples - views' }
GtLAppliedRefactoringExamples >> appliedRefactoringMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| mainDataView |
	mainDataView := self appliedRefactoring llmDataViewsFor: GtLDataView new.
	self
		assertCompositeDataView: mainDataView
		hasTitle: 'Object views'
		viewsCount: 1.
	self assertCompositeView: mainDataView hasMagritteDataViewWithDataKey: nil.
	^mainDataView
]

{ #category : #'examples - basic' }
GtLAppliedRefactoringExamples >> appliedRefactoringSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| dataBlock expected |
	dataBlock := self appliedRefactoringMainDataView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	expected := Dictionary new
			at: #status put: 'applied';
			at: #changesCount put: 1;
			at: #codeChanges put: NeoJSONArray new;
			at: #errorMessage put: nil;
			yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	^ dataBlock
]
