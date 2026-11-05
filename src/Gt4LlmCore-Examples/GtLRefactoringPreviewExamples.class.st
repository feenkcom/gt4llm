Class {
	#name : #GtLRefactoringPreviewExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'examples - basic' }
GtLRefactoringPreviewExamples >> refactoringPreview [
	<gtExample>
	<return: #GtLRefactoringPreview>
	| specification transformations preview |
	specification := (GtLAddMethodSpecification new)
				methodClassName: 'GtLRefactoringPreviewExamples';
				protocolName: 'examples';
				sourceCode: 'previewedMethod ^ 42';
				yourself.
	transformations := GtLCodeTransformations new
				transformations: (Array with: specification).
	preview := (GtLRefactoringPreview
				namespace: transformations applyRefactoring)
				objectId: 'example-object-id';
				yourself.
	self assert: preview changes size equals: 1.
	self assert: preview changes first class equals: GtLRefactoringChange.
	self assert: preview changes first changeDescription
		equals: 'GtLRefactoringPreviewExamples>>previewedMethod'.
	self assert: preview changes first newSource equals: 'previewedMethod ^ 42'.
	self assert: preview objectId equals: 'example-object-id'.
	self assert: preview isApplied not.
	^preview
]

{ #category : #'examples - views' }
GtLRefactoringPreviewExamples >> refactoringPreviewMainDataView [
	<gtExample>
	<return: #GtLCompositeDataView>
	| mainDataView |
	mainDataView := self refactoringPreview llmDataViewsFor: GtLDataView new.
	self
		assertCompositeDataView: mainDataView
		hasTitle: 'Object views'
		viewsCount: 1.
	self assertCompositeView: mainDataView hasMagritteDataViewWithDataKey: nil.
	^mainDataView
]

{ #category : #'examples - serialization' }
GtLRefactoringPreviewExamples >> refactoringPreviewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| dataBlock expected |
	dataBlock := self refactoringPreviewMainDataView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	expected := (Dictionary new)
				at: #changes
					put: (NeoJSONArray with: ((NeoJSONObject new)
									at: #changeDescription
										put: 'GtLRefactoringPreviewExamples>>previewedMethod';
									at: #newSource put: 'previewedMethod ^ 42';
									yourself));
				at: #objectId put: 'example-object-id';
				at: #applied put: false;
				yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	^dataBlock
]
