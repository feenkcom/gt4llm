"
I am the abstract superclass of the specifications of Lepiter transformations: adding a text or code snippet to a page and editing a snippet ({{gtClass:GtLLepiterTransformations}} holds a list of us). Each of us adds Le changes (`LeAddSnippetChange`, `LeSnippetChange`, ...) to a namespace in `asRefactoringIn:`.

I look my pages and snippets up through {{gtClass:GtLLepiterSnippetLocator}}, in my `database`: the logical database unless another one is given with `database:` (examples use an in-memory database). Ambiguous ids, such as a page id that is in several databases, are refused with an error.

Like the code transformation specifications, I answer a `refactoringName`, a `refactoringDescription` and my `changeGroupNames` (`lepiterChanges`), so the namespace can be previewed and applied through {{gtClass:GtLRefactoringPreview}}, which records snapshot-based snippet change results; see {{gtClass:GtLLepiterTransformationSpecificationExamples}}.

Today only the chat page review offers us, and only the concrete edit specifications; the add specifications are not offered (`isConcrete` is false). No MCP tool uses us.
"
Class {
	#name : #GtLLepiterTransformationSpecification,
	#superclass : #Object,
	#instVars : [
		'database'
	],
	#category : #'Gt4LlmCore-Formats'
}

{ #category : #testing }
GtLLepiterTransformationSpecification class >> isConcrete [
	^ false
]

{ #category : #accessing }
GtLLepiterTransformationSpecification class >> refactoringName [
	^ 'Change Lepiter snippet'
]

{ #category : #refactoring }
GtLLepiterTransformationSpecification >> asRefactoring [
	| namespace |
	namespace := GtRBNamespace new.
	^ self asRefactoringIn: namespace.
]

{ #category : #refactoring }
GtLLepiterTransformationSpecification >> asRefactoringIn: aNamespace [
	^ self subclassResponsibility
]

{ #category : #accessing }
GtLLepiterTransformationSpecification >> changeGroupNames [
	"A preview lists my changes by database, page and snippet, with the ids the Lepiter tools take"

	^ #('lepiterChanges')
]

{ #category : #accessing }
GtLLepiterTransformationSpecification >> database [
	"Return the database in which I look my pages and snippets up: the logical database, unless another one was given"

	^ database ifNil: [ LeDatabasesRegistry defaultLogicalDatabase ]
]

{ #category : #accessing }
GtLLepiterTransformationSpecification >> database: aDatabase [
	"Look my pages and snippets up in aDatabase, a logical database or a single database"

	database := aDatabase
]

{ #category : #views }
GtLLepiterTransformationSpecification >> gtChangesFor: aView [
	<gtView>
	^ aView forward
		title: 'Changes';
		priority: 2;
		object: [ self namespaceWithAppliedRefactoring ];
		view: #gtApplyingChangesFor:
]

{ #category : #refactoring }
GtLLepiterTransformationSpecification >> namespaceWithAppliedRefactoring [
	| namespace composite |
	namespace := GtRBNamespace new.
	composite := self asRefactoringIn: namespace.
	composite ifNotNil: [ :each | each primitiveExecute ].
	^ namespace
]

{ #category : #accessing }
GtLLepiterTransformationSpecification >> refactoringDescription [
	"Return a description of the transformation with its parameters"

	^ self refactoringName
]

{ #category : #accessing }
GtLLepiterTransformationSpecification >> refactoringName [
	"Return a short human readable name of the transformation, such as 'Add text snippet'"

	^ self class refactoringName
]
