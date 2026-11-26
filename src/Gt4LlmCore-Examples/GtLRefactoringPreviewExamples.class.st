Class {
	#name : #GtLRefactoringPreviewExamples,
	#superclass : #GtLDomainObjectExamples,
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #'examples - basic' }
GtLRefactoringPreviewExamples >> namedRefactoringPreview [
	"A preview created by the previewRefactoring tool knows the name and the description of the refactoring"

	<gtExample>
	<return: #GtLRefactoringPreview>
	| specification transformations preview |
	specification := GtLAddMethodSpecification new
			methodClassName: 'GtLRefactoringPreviewExamples';
			protocol: 'examples';
			sourceCode: 'previewedMethod ^ 42';
			yourself.
	transformations := GtLCodeTransformations new
			transformations: (Array with: specification).
	self assert: transformations refactoringName equals: 'Add method'.
	preview := (GtLRefactoringPreview
			namespace: transformations applyRefactoring
			refactoringName: transformations refactoringName
			refactoringDescription: transformations refactoringDescription)
			objectId: 'example-object-id';
			yourself.
	self assert: preview refactoringName equals: 'Add method'.
	self
		assert: preview refactoringDescription
		equals: 'Add method previewedMethod ^ 42 in class GtLRefactoringPreviewExamples protocol examples'.
	self assert: preview changes size equals: 1.
	self assert: preview isApplied not.
	^ preview
]

{ #category : #examples }
GtLRefactoringPreviewExamples >> namedRefactoringPreviewSerialization [
	"With includeSources, each listed change of the report has its new source"

	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| report dataBlock |
	report := GtLRefactoringPreviewReport
			refactoring: self namedRefactoringPreview
			displayOptions: (GtLRefactoringDisplayOptions new includeSources: true).
	dataBlock := (report llmDataViewsFor: GtLDataView new)
			serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	self
		assertDataBlock: dataBlock
		hasLlmJsonData: (Dictionary new
				at: 'refactoringName' put: 'Add method';
				at: 'refactoringDescription'
					put: 'Add method previewedMethod ^ 42 in class GtLRefactoringPreviewExamples protocol examples';
				at: 'changesCount' put: 1;
				at: 'objectId' put: 'example-object-id';
				at: 'status' put: 'not applied';
				at: 'changes'
					put: {NeoJSONObject new
								at: 'changeDescription'
									put: 'Add GtLRefactoringPreviewExamples>>#previewedMethod';
								at: 'kind' put: 'added method';
								at: 'target' put: 'GtLRefactoringPreviewExamples>>#previewedMethod';
								at: 'newSource' put: 'previewedMethod ^ 42';
								yourself};
				yourself).
	^ dataBlock
]

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
			protocol: 'examples';
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
	"The tools answer a report of the preview: its LLM data view is the JSON of the response"

	<gtExample>
	<return: #GtLCompositeDataView>
	| mainDataView |
	mainDataView := (GtLRefactoringPreviewReport
			refactoring: self refactoringPreview
			displayOptions: GtLRefactoringDisplayOptions new)
			llmDataViewsFor: GtLDataView new.
	self
		assertCompositeDataView: mainDataView
		hasTitle: 'Object views'
		viewsCount: 1.
	self assertCompositeView: mainDataView hasJsonDataViewWithDataKey: nil.
	^ mainDataView
]

{ #category : #examples }
GtLRefactoringPreviewExamples >> refactoringPreviewPrintString [
	"A preview prints its refactoring name, its number of changes and whether it was applied"

	<gtExample>
	<return: #GtLRefactoringPreview>
	| preview |
	preview := self namedRefactoringPreview.
	self
		assert: preview printString
		equals: 'a GtLRefactoringPreview(Add method: 1 change, not applied)'.
	self
		assert: self refactoringPreview printString
		equals: 'a GtLRefactoringPreview(1 change, not applied)'.
	^ preview
]

{ #category : #examples }
GtLRefactoringPreviewExamples >> refactoringPreviewSerialization [
	"The report of a preview created without a refactoring name and description leaves them out. By default the changes are listed without their sources"

	<gtExample>
	<return: #GtLPrimitiveMessageDataBlock>
	| dataBlock expected |
	dataBlock := self refactoringPreviewMainDataView serializeToLlmPrimiteData.
	self assertDataBlockHasOnlyJsonData: dataBlock.
	expected := Dictionary new
			at: 'changesCount' put: 1;
			at: 'objectId' put: 'example-object-id';
			at: 'status' put: 'not applied';
			at: 'changes'
				put: {NeoJSONObject new
							at: 'changeDescription'
								put: 'Add GtLRefactoringPreviewExamples>>#previewedMethod';
							at: 'kind' put: 'added method';
							at: 'target' put: 'GtLRefactoringPreviewExamples>>#previewedMethod';
							yourself};
			yourself.
	self assertDataBlock: dataBlock hasLlmJsonData: expected.
	^ dataBlock
]
