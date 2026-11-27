"
I show the renameMethod tool and the RenameMethod preview on temporary classes made by the dummy generator: a root class with a subclass, and an unrelated class in another package ({{gtMethod:GtLMagritteToolForMethodRenameExamples>>#installFixtures}}). The root, its class side and the unrelated class implement the method to rename, so the examples show that the rename is global.
The selectors are made from the names of the temporary classes, so no other method or Lepiter snippet uses them. My methods name them only in strings: a rename rewrites the symbols of all the methods in the image, mine included.
"
Class {
	#name : #GtLMagritteToolForMethodRenameExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#instVars : [
		'objectStorage',
		'dummies'
	],
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #fixtures }
GtLMagritteToolForMethodRenameExamples >> dummyPackagesInOrder [
	"The temporary packages, ordered by the names of their classes, so that the root and its subclass come from the first one"

	^ dummies dummyPackages
		sorted: [ :a :b | a dummyClasses first className <= b dummyClasses first className ]
]

{ #category : #private }
GtLMagritteToolForMethodRenameExamples >> expectedMethodChanges [
	"The kind and target of each method change: the three implementors are removed and added under the new name, the sender in the subclass and the method with the symbol are modified"

	| implementors |
	implementors := {self rootClass name.
			self rootClass class name.
			self unrelatedClass name}.
	^ (implementors
		collect: [ :each | 'removed method' -> (each , '>>#' , self oldSelector) ])
		, (implementors
				collect: [ :each | 'added method' -> (each , '>>#' , self newSelector) ])
		, {'modified method' -> (self subclass name , '>>#useTarget').
				'modified method' -> (self unrelatedClass name , '>>#targetSymbol')}
]

{ #category : #fixtures }
GtLMagritteToolForMethodRenameExamples >> installFixtures [
	"The root, its class side and the unrelated class implement the method to rename. The subclass sends it, the class side of the root also sends it, and the unrelated class names it as a symbol.
	Keep the fixture changes out of the global undo/redo history"

	^ GtRefactoryChangeManager
		isolatedInstanceDuring: [ dummies := GtPharoDummiesGenerator withPackages: 2 classHierarchy: 2.
			self rootClass
				compile: self oldSelector , ' anObject ^ anObject'
				classified: 'examples'.
			self rootClass class
				compile: self oldSelector , ' anObject ^ self new ' , self oldSelector , ' anObject'
				classified: 'examples'.
			self subclass
				compile: 'useTarget ^ self ' , self oldSelector , ' 42'
				classified: 'examples'.
			self unrelatedClass
				compile: self oldSelector , ' anObject ^ nil'
				classified: 'examples'.
			self unrelatedClass
				compile: 'targetSymbol ^ #' , self oldSelector
				classified: 'examples'.
			self rootClass ]
]

{ #category : #fixtures }
GtLMagritteToolForMethodRenameExamples >> newSelector [
	^ 'renamedTargetOf' , self rootClass name , ':'
]

{ #category : #private }
GtLMagritteToolForMethodRenameExamples >> objectStorage [
	^ objectStorage ifNil: [ objectStorage := GtLObjectStorage new ]
]

{ #category : #fixtures }
GtLMagritteToolForMethodRenameExamples >> oldSelector [
	"A keyword selector made from the name of the temporary root class: no other code uses it"

	^ 'targetOf' , self rootClass name , ':'
]

{ #category : #private }
GtLMagritteToolForMethodRenameExamples >> performRenameWith: aDictionary [
	"The changes are undoable: keep them out of the global undo/redo history.
	Name the tool call, as the summarizers select the tool calls by name"

	| toolCall aTool |
	aTool := GtLMagritteToolForMethodRename new.
	toolCall := GtLFunctionToolCall new
			name: aTool name;
			rawArguments: aDictionary;
			yourself.
	GtRefactoryChangeManager
		isolatedInstanceDuring: [ aTool
				performToolCall: toolCall
				inContext: (GtLToolExecutionContext new objectStorage: self objectStorage) ].
	^ toolCall
]

{ #category : #examples }
GtLMagritteToolForMethodRenameExamples >> previewRenameMethod [
	"previewRefactoring lists the changes of a RenameMethod in the method and Lepiter groups, each method once, and changes nothing"

	<gtExample>
	| call preview |
	[ self installFixtures.
	call := self
			executeTool: GtLToolForPreviewRefactoring new
			withArguments: (Dictionary new
					at: 'transformations'
						put: {Dictionary new
									at: 'RenameMethod' put: self renameArguments;
									yourself};
					yourself)
			inContext: (GtLToolExecutionContext new objectStorage: self objectStorage).
	preview := self modelOf: call.
	self assert: preview class equals: GtLRefactoringPreview.
	self
		assert: preview changeGroupNames
		equals: #('methodChanges' 'lepiterChanges').
	self
		assert: (preview report changeGroups methodChanges displayedEntries
				collect: [ :each | each kind -> each target ]) asBag
		equals: self expectedMethodChanges asBag.
	self assert: (self rootClass includesLocalSelector: self oldSelector asSymbol).
	self
		assert: (self rootClass includesLocalSelector: self newSelector asSymbol) not ]
		ensure: [ self removeFixtures ].
	^ preview
]

{ #category : #examples }
GtLMagritteToolForMethodRenameExamples >> refuseRenameToSelectorOfSubclass [
	"The subclass already defines the new selector: the renamed method of the root would be overridden by it. Nothing is renamed"

	<gtExample>
	| call |
	[ self installFixtures.
	GtRefactoryChangeManager
		isolatedInstanceDuring: [ self subclass
				compile: self newSelector , ' anObject ^ 0'
				classified: 'examples' ].
	call := self performRenameWith: self renameArguments.
	self
		assertProblem: (self modelOf: call)
		withErrorMessage: self newSelector , ' is already defined in the hierarchy of an implementor of '
				, self oldSelector , ', which the rename renames: ' , self rootClass name
				, ' (' , self newSelector , ' in ' , self subclass name
				, '). The renamed methods would override these methods or be overridden by them'.
	self assert: (self rootClass includesLocalSelector: self oldSelector asSymbol) ]
		ensure: [ self removeFixtures ].
	^ call
]

{ #category : #fixtures }
GtLMagritteToolForMethodRenameExamples >> removeFixtures [
	"Remove the temporary classes and packages, out of the global undo/redo history"

	dummies ifNil: [ ^ self ].
	GtRefactoryChangeManager
		isolatedInstanceDuring: [ self removeDummies: dummies ].
	dummies := nil
]

{ #category : #private }
GtLMagritteToolForMethodRenameExamples >> renameArguments [
	^ Dictionary new
		at: 'methodClassName' put: self rootClass name asString;
		at: 'classSide' put: false;
		at: 'methodNameToRename' put: self oldSelector;
		at: 'newMethodName' put: self newSelector;
		yourself
]

{ #category : #examples }
GtLMagritteToolForMethodRenameExamples >> renameMethodEverywhere [
	"The rename is global: the implementors in the root, its class side and the unrelated class are renamed, and the send in the subclass and the symbol in the unrelated class are rewritten. Each method is changed once. No Lepiter snippet uses the selector"

	<gtExample>
	| call result groups oldSelector newSelector |
	[ self installFixtures.
	self assert: self subclass superclass == self rootClass.
	oldSelector := self oldSelector asSymbol.
	newSelector := self newSelector asSymbol.
	call := self performRenameWith: self renameArguments.
	result := self modelOf: call.
	self assert: result class equals: GtLRefactoringResult.
	self assert: result status equals: 'applied'.
	self assert: result refactoringName equals: 'Rename method'.
	self
		assert: result refactoringDescription
		equals: 'Rename method ' , self rootClass name , '>>#' , oldSelector , ' to '
				, newSelector.
	{self rootClass.
		self rootClass class.
		self unrelatedClass}
		do: [ :aBehavior | 
			self assert: (aBehavior includesLocalSelector: newSelector).
			self assert: (aBehavior includesLocalSelector: oldSelector) not ].
	self
		assert: ((self rootClass class >> newSelector) sourceCode
				includesSubstring: 'self new ' , newSelector).
	self
		assert: ((self subclass >> #useTarget) sourceCode includesSubstring: newSelector).
	self assert: (self subclass new perform: #useTarget) equals: 42.
	self
		assert: ((self unrelatedClass >> #targetSymbol) sourceCode
				includesSubstring: '#' , newSelector).
	groups := result report changeGroups.
	self
		assert: (groups methodChanges displayedEntries
				collect: [ :each | each kind -> each target ]) asBag
		equals: self expectedMethodChanges asBag.
	self assert: groups lepiterChanges isEmpty ] ensure: [ self removeFixtures ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForMethodRenameExamples >> renameMethodResponse [
	"The response lists the groups of applied changes and gives the objectId of the stored result, which keeps all the changes"

	<gtExample>
	| call json methodChanges |
	[ self installFixtures.
	call := self performRenameWith: self renameArguments.
	json := self jsonOf: call.
	self assert: (json at: 'status') equals: 'applied'.
	self assert: (json at: 'changesCount') equals: 8.
	self assert: (json includesKey: 'classChanges') not.
	methodChanges := json at: 'methodChanges'.
	self assert: (methodChanges at: 'totalCount') equals: 8.
	self
		assert: (methodChanges at: 'kindCounts')
		equals: (Dictionary new
				at: 'added method' put: 3;
				at: 'modified method' put: 2;
				at: 'removed method' put: 3;
				yourself).
	self assert: ((json at: 'lepiterChanges') at: 'totalSnippetsCount') equals: 0.
	self
		assert: (self objectStorage objectAt: (json at: 'objectId')) == (self modelOf: call) ]
		ensure: [ self removeFixtures ].
	^ json
]

{ #category : #fixtures }
GtLMagritteToolForMethodRenameExamples >> rootClass [
	^ self dummyPackagesInOrder first dummyClasses first realClass
]

{ #category : #fixtures }
GtLMagritteToolForMethodRenameExamples >> subclass [
	^ self dummyPackagesInOrder first dummyClasses last realClass
]

{ #category : #examples }
GtLMagritteToolForMethodRenameExamples >> summaryOfRenamedMethod [
	"In the summary, a rename removes the implementors under the old selector, adds them under the new one and modifies the senders"

	<gtExample>
	| call aGroup summarizer |
	[ self installFixtures.
	call := self performRenameWith: self renameArguments.
	aGroup := GtLMessagesGroup new.
	aGroup
		add: (GtLToolMessage new
				toolCall: call;
				output: call result;
				yourself).
	summarizer := aGroup toolCallsSummarizers
			detect: [ :each | each class = GtLCodeChangesToolCallsSummarizer ].
	self assert: summarizer relevantToolCalls size equals: 1.
	self
		assert: (summarizer codeChanges collect: [ :each | each label ]) asBag sortedCounts
				asArray
		equals: {3 -> 'Refactoring (Rename method): added method'.
				3 -> 'Refactoring (Rename method): removed method'.
				2 -> 'Refactoring (Rename method): modified method'} ]
		ensure: [ self removeFixtures ].
	^ summarizer
]

{ #category : #examples }
GtLMagritteToolForMethodRenameExamples >> undoRenameMethod [
	<gtExample>
	| call |
	[ self installFixtures.
	call := self performRenameWith: self renameArguments.
	GtRefactoryChangeManager
		isolatedInstanceDuring: [ (self modelOf: call) undoChange execute ].
	{self rootClass.
		self rootClass class.
		self unrelatedClass}
		do: [ :aBehavior | 
			self assert: (aBehavior includesLocalSelector: self oldSelector asSymbol).
			self assert: (aBehavior includesLocalSelector: self newSelector asSymbol) not ].
	self
		assert: (self subclass >> #useTarget) sourceCode
		equals: 'useTarget ^ self ' , self oldSelector , ' 42' ]
		ensure: [ self removeFixtures ].
	^ call
]

{ #category : #fixtures }
GtLMagritteToolForMethodRenameExamples >> unrelatedClass [
	^ self dummyPackagesInOrder last dummyClasses first realClass
]
