"
Examples of the Lepiter transformation specifications ({{gtClass:GtLLepiterTransformationSpecification}}): adding a text or code snippet and editing a text snippet, previewed and applied like the code transformations, through {{gtClass:GtLRefactoringPreview}}. They use an in-memory database (`LeDatabase new`), given to the specifications with `database:`, which is never added to the logical database.
"
Class {
	#name : #GtLLepiterTransformationSpecificationExamples,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Examples-Refactorings'
}

{ #category : #examples }
GtLLepiterTransformationSpecificationExamples >> appliedSnippetTransformations [
	"Applying the preview adds the text snippet with the text of the markdown, adds the code snippet and edits the first snippet. Each change is linked to the result of its own snippet, built from snapshots, and the views name each change as its result does"

	<gtExample>
	| aPreview aPage aResult theResults |
	aPreview := self previewOfSnippetTransformations.
	aPage := aPreview changes third change snippet page.
	aResult := GtRefactoryChangeManager isolatedInstanceDuring: [ aPreview apply ].
	self assert: aResult hasFailed not.
	theResults := aResult lepiterChangeResults.
	self
		assert: (theResults collect: [ :each | each class ]) asArray
		equals: {GtLLepiterSnippetAdditionResult.
				GtLLepiterSnippetAdditionResult.
				GtLLepiterSnippetModificationResult}.
	self assert: theResults first newSnippet contentString equals: 'A new text'.
	self assert: theResults first newSnippet snippetType equals: 'text'.
	self assert: theResults second newSnippet contentString equals: '3 + 4'.
	self assert: theResults second newSnippet snippetType equals: 'pharo'.
	self assert: theResults third oldSnippet contentString equals: 'First text'.
	self assert: theResults third newSnippet contentString equals: 'Edited text'.
	self
		assert: (aPreview changes collect: [ :each | each codeChangeResult ]) asArray
		equals: theResults asArray.
	self
		assert: (aPreview changes collect: [ :each | each gtViewChangeTarget ]) asArray
		equals: (theResults collect: [ :each | each gtViewChangeTarget ]) asArray.
	self assert: aPage children size equals: 3.
	self assert: aPage children first string equals: 'Edited text'.
	self assert: (aPage children second string isKindOf: String).
	self assert: aPage children second string equals: 'A new text'.
	self assert: aPage children third code equals: '3 + 4'.
	^ aResult
]

{ #category : #examples }
GtLLepiterTransformationSpecificationExamples >> dashedPageUidIsAccepted [
	"A specification can name its page by the dashed form of the page UUID too"

	<gtExample>
	| aPage aSpecification aNamespace |
	aPage := self pageWithTextSnippet.
	aSpecification := GtLLepiterAddTextSnippetTransformationSpecification new
			database: aPage database;
			pageUidString: aPage uid asString;
			newSnippetText: (GtLMarkdown new content: 'A new text');
			yourself.
	self
		assert: aSpecification refactoringDescription
		equals: 'Add text snippet to page Transformations page'.
	self assert: aSpecification pageUid equals: aPage uid.
	aNamespace := aSpecification namespaceWithAppliedRefactoring.
	self assert: aNamespace changes changes size equals: 1.
	self assert: aNamespace changes changes first gtLlmPageOfParent == aPage.
	^ aSpecification
]

{ #category : #examples }
GtLLepiterTransformationSpecificationExamples >> pageWithTextSnippet [
	"A page with one text snippet, in an in-memory database"

	<gtExample>
	| aPage |
	aPage := LePage named: 'Transformations page'.
	LeDatabase new addPage: aPage.
	aPage addSnippet: (LeTextSnippet string: 'First text').
	self assert: aPage children size equals: 1.
	^ aPage
]

{ #category : #examples }
GtLLepiterTransformationSpecificationExamples >> previewOfSnippetTransformations [
	"A preview of Lepiter transformations is named and grouped like the one of code transformations. The snippets to add are named by the page of their parent, and nothing changes before the preview is applied"

	<gtExample>
	| aPage aPreview |
	aPage := self pageWithTextSnippet.
	aPreview := self previewOfTransformations: (self transformationsOn: aPage).
	self
		assert: aPreview refactoringName
		equals: 'Add text snippet, Add code snippet, Edit text snippet'.
	self
		assert: aPreview refactoringDescription
		equals: 'Add text snippet to page Transformations page; Add code snippet to page Transformations page; Edit text snippet '
				, aPage children first uid uidString , ' in page Transformations page'.
	self assert: aPreview changeGroupNames equals: #('lepiterChanges').
	self
		assert: (aPreview changes collect: [ :each | each kind ]) asArray
		equals: #('added snippet' 'added snippet' 'modified snippet').
	self
		assert: aPreview changes first target
		equals: 'new snippet in page Transformations page'.
	self
		assert: aPreview changes first changeDescription
		equals: 'Add snippet in ' , aPage gtDisplayString.
	self
		assert: aPreview changes first gtViewChangeTarget
		equals: 'text: A new text (page Transformations page)'.
	self assert: aPreview changes first newSource equals: 'A new text'.
	self assert: aPreview changes third newSource equals: 'Edited text'.
	self assert: aPage children size equals: 1.
	self assert: aPage children first string equals: 'First text'.
	^ aPreview
]

{ #category : #private }
GtLLepiterTransformationSpecificationExamples >> previewOfTransformations: aTransformations [
	^ GtLRefactoringPreview
		namespace: aTransformations applyRefactoring
		refactoringName: aTransformations refactoringName
		refactoringDescription: aTransformations refactoringDescription
		changeGroupNames: aTransformations changeGroupNames
]

{ #category : #private }
GtLLepiterTransformationSpecificationExamples >> transformationsOn: aPage [
	"Add a text snippet and a code snippet to aPage, and edit its first snippet. The specifications look the page up in its own database"

	^ GtLLepiterTransformations new
		transformations: {GtLLepiterAddTextSnippetTransformationSpecification new
					database: aPage database;
					pageUidString: aPage uidString;
					newSnippetText: (GtLMarkdown new content: 'A new text');
					yourself.
				GtLLepiterAddCodeSnippetTransformationSpecification new
					database: aPage database;
					pageUidString: aPage uidString;
					newSnippetCode: '3 + 4';
					yourself.
				GtLLepiterEditTextSnippetTransformationSpecification new
					database: aPage database;
					pageUidString: aPage uidString;
					snippetUid: aPage children first uid;
					updatedSnippetText: (GtLMarkdown new content: 'Edited text');
					yourself};
		yourself
]

{ #category : #examples }
GtLLepiterTransformationSpecificationExamples >> unknownPageIsRefused [
	"A page that is not in the database of the specification is refused, and the description then names the page by its uid"

	<gtExample>
	| aSpecification aPageUid anError |
	aPageUid := UUID new asString36.
	aSpecification := GtLLepiterAddTextSnippetTransformationSpecification new
			database: self pageWithTextSnippet database;
			pageUidString: aPageUid;
			newSnippetText: (GtLMarkdown new content: 'A new text');
			yourself.
	anError := [ aSpecification asRefactoring.
		nil ] on: Error do: [ :each | each return: each ].
	self assert: anError notNil.
	self
		assert: (anError messageText includesSubstring: 'Could not locate page with id').
	self
		assert: aSpecification refactoringDescription
		equals: 'Add text snippet to page ' , aPageUid.
	^ aSpecification
]

{ #category : #examples }
GtLLepiterTransformationSpecificationExamples >> unknownSnippetIsRefused [
	"An edit of a snippet that is not in the page, or without a snippet uid, is refused when the change is built"

	<gtExample>
	| aPage aSpecification theMessages |
	aPage := self pageWithTextSnippet.
	aSpecification := GtLLepiterEditTextSnippetTransformationSpecification new
			database: aPage database;
			pageUidString: aPage uidString;
			snippetUid: self pageWithTextSnippet children first uid;
			updatedSnippetText: (GtLMarkdown new content: 'Edited text');
			yourself.
	theMessages := OrderedCollection new.
	theMessages
		add: ([ aSpecification asRefactoring.
			nil ] on: Error do: [ :each | each return: each messageText ]).
	aSpecification snippetUid: nil.
	theMessages
		add: ([ aSpecification asRefactoring.
			nil ] on: Error do: [ :each | each return: each messageText ]).
	self
		assert: (theMessages first includesSubstring: 'Could not locate snippet with id').
	self assert: (theMessages second includesSubstring: 'Missing snippet uid').
	self assert: aPage children first string equals: 'First text'.
	^ theMessages asArray
]
