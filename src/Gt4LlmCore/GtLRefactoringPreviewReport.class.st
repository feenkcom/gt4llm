"
I report a {{gtClass:GtLRefactoringPreview}}: what the previewRefactoring and previewRewrite tools answer. See {{gtClass:GtLRefactoringReport}}.
"
Class {
	#name : #GtLRefactoringPreviewReport,
	#superclass : #GtLRefactoringReport,
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #views }
GtLRefactoringPreviewReport >> gtChangesFor: aView [
	"The diff of the previewed changes, as long as the preview is not applied"

	<gtView>
	<gtLlmView>
	refactoring result ifNotNil: [ ^ aView empty ].
	^ aView forward
		title: 'Diff';
		priority: 1;
		object: [ refactoring ];
		view: #gtChangesFor:
]

{ #category : #views }
GtLRefactoringPreviewReport >> gtCodeChangesFor: aView [
	"What the previewed changes changed in the image, once the preview is applied"

	<gtView>
	<gtLlmView>
	refactoring result ifNil: [ ^ aView empty ].
	^ aView forward
		title: 'Code changes';
		priority: 1;
		object: [ refactoring ];
		view: #gtCodeChangesFor:
]

{ #category : #views }
GtLRefactoringPreviewReport >> gtNewSourcesFor: aView [
	"The code or text that each change of the preview introduces, also when the response does not list it"

	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'New sources';
		priority: 4;
		object: [ refactoring ];
		view: #gtNewSourcesFor:
]

{ #category : #views }
GtLRefactoringPreviewReport >> gtRefactoringChangesFor: aView [
	"All the changes of the preview, also the ones the response does not list"

	<gtView>
	<gtLlmView>
	^ aView forward
		title: 'Refactoring changes';
		priority: 2;
		object: [ refactoring ];
		view: #gtRefactoringChangesFor:
]

{ #category : #converting }
GtLRefactoringPreviewReport >> llmJsonObject [
	| json |
	json := NeoJSONObject new.
	self addRefactoringPropertiesTo: json.
	refactoring objectId ifNotNil: [ :anId | json at: 'objectId' put: anId ].
	json at: 'status' put: refactoring applicationStatus.
	changeGroups
		ifNil: [ json
				at: 'changes'
				put: (refactoring changes
						collect: [ :each | each llmJsonObjectIncludingSources: displayOptions includeSources ]
						as: Array) ]
		ifNotNil: [ changeGroups addJsonPropertiesTo: json ].
	^ json
]
