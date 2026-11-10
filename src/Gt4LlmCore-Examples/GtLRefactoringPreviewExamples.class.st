Class {
	#name : #GtLRefactoringPreviewExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLRefactoringPreviewExamples >> pushUpMethodPreview [
	"A push up previews slot and method changes. Each change keeps its RB change,
	has a kind and a target, and only the added method has a new source.
	The preview is never applied."

	<gtExample>
	<return: #GtLRefactoringPreview>
	| specification namespace preview changesByKind |
	specification := GtLPushUpMethodSpecification new
			methodNameToPushUp: #initialize;
			methodClassName: DiffPatchVisitor name;
			targetClassName: DiffVisitor name.
	namespace := specification namespaceWithAppliedRefactoring.
	preview := GtLRefactoringPreview namespace: namespace.
	self assert: preview changes size equals: namespace changes gtBasicChanges size.
	preview changes
		with: namespace changes gtBasicChanges
		do: [ :eachChange :eachRBChange | self assert: eachChange change == eachRBChange ].
	changesByKind := preview changes groupedBy: [ :each | each kind ].
	self assert: (changesByKind at: 'added method') size equals: 1.
	self
		assert: (changesByKind at: 'added method') first target
		equals: 'DiffVisitor>>#initialize'.
	self assert: (changesByKind at: 'added method') first hasNewSource.
	self assert: (changesByKind at: 'removed method') size equals: 2.
	self
		assert: (changesByKind at: 'added slot') first target
		equals: 'DiffVisitor'.
	self assert: (changesByKind at: 'removed slot') notEmpty.
	(preview changes reject: [ :each | each kind = 'added method' ])
		do: [ :each | self assert: each newSource isNil ].
	^ preview
]

{ #category : #'examples - basic' }
GtLRefactoringPreviewExamples >> refactoringPreview [
	<gtExample>
	<return: #GtLRefactoringPreview>
	| specification transformations preview |
	specification := GtLAddMethodSpecification new
			methodClassName: 'GtLRefactoringPreviewExamples';
			protocolName: 'examples';
			sourceCode: 'previewedMethod ^ 42';
			yourself.
	transformations := GtLCodeTransformations new
			transformations: (Array with: specification).
	preview := (GtLRefactoringPreview namespace: transformations applyRefactoring)
			objectId: 'example-object-id';
			yourself.
	self assert: preview changes size equals: 1.
	self assert: preview changes first class equals: GtLRefactoringChange.
	self
		assert: preview changes first changeDescription
		equals: 'Add GtLRefactoringPreviewExamples>>#previewedMethod'.
	self assert: preview changes first newSource equals: 'previewedMethod ^ 42'.
	self assert: preview objectId equals: 'example-object-id'.
	self assert: preview isApplied not.
	^ preview
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

{ #category : #examples }
GtLRefactoringPreviewExamples >> refactoringPreviewSerialization [
	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| dataBlock expected |
	dataBlock := self refactoringPreviewMainDataView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	expected := Dictionary new
			at: #changes
				put: (NeoJSONArray
						with: (NeoJSONObject new
								at: #changeDescription
									put: 'Add GtLRefactoringPreviewExamples>>#previewedMethod';
								at: #kind put: 'added method';
								at: #target put: 'GtLRefactoringPreviewExamples>>#previewedMethod';
								at: #newSource put: 'previewedMethod ^ 42';
								yourself));
			at: #changesCount put: 1;
			at: #objectId put: 'example-object-id';
			at: #applied put: false;
			yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	^ dataBlock
]
