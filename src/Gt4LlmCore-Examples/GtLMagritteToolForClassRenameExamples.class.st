"
I show the renameClass tool and the RenameClass preview on temporary classes made by the dummy generator: a class with a subclass, referenced by another class, and a used trait. The temporary classes have unique names, so no other code or Lepiter page refers to them; they are removed with their packages after each example, also after a rename.
"
Class {
	#name : #GtLMagritteToolForClassRenameExamples,
	#superclass : #GtLAbstractMagritteFunctionToolExamples,
	#instVars : [
		'objectStorage',
		'dummies'
	],
	#category : #'Gt4LlmCore-Examples'
}

{ #category : #examples }
GtLMagritteToolForClassRenameExamples >> appliedRenameListsChangedSnippets [
	"After a rename, the applied refactoring lists the changed snippets, and the definition of the subclass as the preview showed it"

	<gtExample>
	| transformations namespace aRenameChange aPage aSnippet preview applied lepiterChanges previewDefinition appliedDefinition |
	[ self installClassFixtures.
	transformations := GtLCodeTransformations new
			transformations: {GtLRenameClassSpecification new
						className: self targetName;
						newClassName: self renamedTargetName;
						yourself}.
	namespace := transformations applyRefactoring.
	namespace changes
		gtAllChangesDo: [ :each | (each isKindOf: RBRenameClassChange) ifTrue: [ aRenameChange := each ] ].
	aPage := LePage named: 'Using the target'.
	LeDatabase new addPage: aPage.
	aSnippet := LePharoSnippet code: self targetName , ' new'.
	aPage addSnippet: aSnippet.
	aRenameChange
		addChange: (LeSnippetChange new
				snippet: aSnippet;
				newSource: self renamedTargetName , ' new';
				yourself).
	preview := GtLRefactoringPreview
			namespace: namespace
			refactoringName: transformations refactoringName
			refactoringDescription: transformations refactoringDescription
			changeGroupNames: transformations changeGroupNames.
	previewDefinition := (preview changeEntries
			detect: [ :each | each groupKind = #class and: [ each className = self subclassName ] ])
			newSource.
	applied := GtRefactoryChangeManager isolatedInstanceDuring: [ preview apply ].
	self assert: applied status equals: 'applied'.
	self assert: aSnippet code equals: self renamedTargetName , ' new'.
	lepiterChanges := applied report changeGroups lepiterChanges.
	self assert: lepiterChanges totalSnippetsCount equals: 1.
	self
		assert: lepiterChanges entries first newSource
		equals: self renamedTargetName , ' new'.
	appliedDefinition := (applied changeEntries
			detect: [ :each | each groupKind = #class and: [ each className = self subclassName ] ])
			newSource.
	self assert: appliedDefinition equals: previewDefinition.
	self
		assert: (applied changeEntries
				detect: [ :each | each groupKind = #class and: [ each isRename ] ])
				newSource isNil ] ensure: [ self removeFixtures ].
	^ applied
]

{ #category : #fixtures }
GtLMagritteToolForClassRenameExamples >> classNamed: aString [
	^ Smalltalk globals at: aString asSymbol ifAbsent: [ nil ]
]

{ #category : #fixtures }
GtLMagritteToolForClassRenameExamples >> dummyPackagesInOrder [
	"The temporary packages, ordered by the names of their classes: the changes of the target and its subclass are listed before the ones of the referencer"

	^ dummies dummyPackages
		sorted: [ :a :b | a dummyClasses first className <= b dummyClasses first className ]
]

{ #category : #private }
GtLMagritteToolForClassRenameExamples >> expectedMethodTargets [
	"The methods of the renamed class are reported under its new name, before the ones of its subclass and of the referencer"

	^ {self renamedTargetName , '>>#itself'.
		self renamedTargetName , ' class>>#make'.
		self subclassName , '>>#parent'.
		self referencerName , '>>#target'.
		self referencerName , '>>#targetName'}
]

{ #category : #fixtures }
GtLMagritteToolForClassRenameExamples >> fixtureClassNamed: aString with: aBuilderBlock [
	"Add a class to the temporary package of the target: it is removed with the package"

	^ Smalltalk classInstaller
		make: [ :aBuilder | 
			aBuilder
				name: aString asSymbol;
				package: self dummyPackagesInOrder first packageName.
			aBuilderBlock value: aBuilder ]
]

{ #category : #fixtures }
GtLMagritteToolForClassRenameExamples >> installClassFixtures [
	"Temporary classes in two temporary packages: a target with a subclass, referenced by its own methods on both sides, by its subclass and by a class of the other package, also as a symbol.
	Keep the fixture changes out of the global undo/redo history"

	^ GtRefactoryChangeManager
		isolatedInstanceDuring: [ | aTarget aReferencer |
			dummies := GtPharoDummiesGenerator withPackages: 2 classHierarchy: 2.
			aTarget := self targetDummy realClass.
			aTarget compile: 'itself ^ ' , self targetName classified: 'examples'.
			aTarget class
				compile: 'make ^ ' , self targetName , ' new'
				classified: 'examples'.
			self subclassDummy realClass
				compile: 'parent ^ ' , self targetName
				classified: 'examples'.
			aReferencer := self referencerDummy realClass.
			aReferencer
				compile: 'target ^ ' , self targetName , ' new'
				classified: 'examples'.
			aReferencer
				compile: 'targetName ^ #' , self targetName
				classified: 'examples'.
			aTarget ]
]

{ #category : #fixtures }
GtLMagritteToolForClassRenameExamples >> installTraitFixtures [
	"A trait and a class using it, in a temporary package.
	Keep the fixture changes out of the global undo/redo history"

	^ GtRefactoryChangeManager
		isolatedInstanceDuring: [ | aTrait |
			dummies := GtPharoDummiesGenerator withPackages: 1 classHierarchy: 1.
			aTrait := self
					fixtureClassNamed: self traitName
					with: [ :aBuilder | aBuilder beTrait ].
			aTrait compile: 'traitMethod ^ ' , self traitName classified: 'examples'.
			self
				fixtureClassNamed: self traitUserName
				with: [ :aBuilder | 
					aBuilder
						superclass: Object;
						traitComposition: aTrait ].
			aTrait ]
]

{ #category : #private }
GtLMagritteToolForClassRenameExamples >> objectStorage [
	^ objectStorage ifNil: [ objectStorage := GtLObjectStorage new ]
]

{ #category : #private }
GtLMagritteToolForClassRenameExamples >> performRenameWith: aDictionary [
	^ self
		performTool: GtLMagritteToolForClassRename new
		withArguments: aDictionary
]

{ #category : #private }
GtLMagritteToolForClassRenameExamples >> performTool: aTool withArguments: aDictionary [
	"The changes are undoable: keep them out of the global undo/redo history.
	Name the tool call, as the summarizers select the tool calls by name"

	| toolCall |
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
GtLMagritteToolForClassRenameExamples >> previewAndApplyRenameClass [
	"previewRefactoring gives a grouped preview of the rename without applying it; applyRefactoring applies it.
	The 7 changes are the rename, the definition of the subclass and 5 methods. No snippet uses the fixtures: lepiterChanges is empty"

	<gtExample>
	| previewCall preview groups applyCall json methodChanges |
	[ self installClassFixtures.
	previewCall := self
			performTool: GtLToolForPreviewRefactoring new
			withArguments: (Dictionary new
					at: 'transformations'
						put: {Dictionary new
									at: 'RenameClass' put: self renameTargetArguments;
									yourself};
					at: 'displayOptions' put: {'classesLimit' -> 1} asDictionary;
					yourself).
	preview := self modelOf: previewCall.
	self assert: preview class equals: GtLRefactoringPreview.
	self assert: preview groupsChanges.
	self assert: preview isApplied not.
	self assert: (self classNamed: self targetName) notNil.
	self assert: preview changesCount equals: 7.
	groups := previewCall result targetObject changeGroups.
	self assert: groups classChanges totalCount equals: 2.
	self assert: groups classChanges displayedCount equals: 1.
	self assert: groups classChanges displayedEntries first isRename.
	self
		assert: (groups methodChanges displayedEntries collect: [ :each | each target ]) asArray
		equals: self expectedMethodTargets.
	self
		assert: ((groups methodChanges displayedEntries
				detect: [ :each | each methodName = 'itself' ]) newSource
				includesSubstring: self renamedTargetName).
	json := self jsonOf: previewCall.
	self assert: (json includesKey: 'changes') not.
	self assert: ((json at: 'lepiterChanges') at: 'totalSnippetsCount') equals: 0.
	self assert: ((json at: 'lepiterChanges') at: 'databases') isEmpty.
	self assert: (json includesKey: 'otherChanges') not.
	self assert: ((json at: 'classChanges') at: 'classes') size equals: 1.

	applyCall := self
			performTool: GtLToolForApplyRefactoring new
			withArguments: (Dictionary new
					at: 'objectId' put: preview objectId;
					at: 'displayOptions' put: {'includeChanges' -> false} asDictionary;
					yourself).
	json := self jsonOf: applyCall.
	self assert: (json at: 'status') equals: 'applied'.
	self assert: (json includesKey: 'methodChanges') not.
	self assert: (self classNamed: self renamedTargetName) notNil.
	methodChanges := preview changes
			select: [ :each | each matchingChange isKindOf: RBAddMethodChange ].
	self assert: methodChanges size equals: 5.
	self
		assert: (methodChanges allSatisfy: [ :each | each codeChangeResult notNil ]) ]
		ensure: [ self removeFixtures ].
	^ applyCall
]

{ #category : #examples }
GtLMagritteToolForClassRenameExamples >> previewAndApplyWithDifferentDisplayOptions [
	"Each tool call answers a report built for its own display options: the preview report lists the previewed changes, the result report the changes made in the image. The preview and the result are stored, each under its own objectId, and keep all their changes"

	<gtExample>
	| previewCall preview applyCall applied appliedJson fullJson |
	[ self installClassFixtures.
	previewCall := self
			performTool: GtLToolForPreviewRefactoring new
			withArguments: (Dictionary new
					at: 'transformations'
						put: {Dictionary new
									at: 'RenameClass' put: self renameTargetArguments;
									yourself};
					at: 'displayOptions' put: {'methodsLimit' -> 1} asDictionary;
					yourself).
	preview := self modelOf: previewCall.
	self
		assert: previewCall result targetObject displayOptions methodsLimit
		equals: 1.
	applyCall := self
			performTool: GtLToolForApplyRefactoring new
			withArguments: (Dictionary new
					at: 'objectId' put: preview objectId;
					at: 'displayOptions'
						put: {'methodsLimit' -> 3.
								'includeSources' -> true} asDictionary;
					yourself).
	applied := self modelOf: applyCall.
	self assert: applied class equals: GtLRefactoringResult.
	self assert: applied groupsChanges.
	self assert: applied preview == preview.
	self assert: preview result == applied.

	appliedJson := self jsonOf: applyCall.
	self assert: (appliedJson at: 'objectId') equals: applied objectId.
	self assert: applied objectId ~= preview objectId.
	self assert: (self objectStorage objectAt: applied objectId) == applied.
	self assert: ((appliedJson at: 'methodChanges') at: 'displayedCount') equals: 3.
	self
		assert: (((appliedJson at: 'methodChanges') at: 'methods')
				allSatisfy: [ :each | each includesKey: 'newSource' ]).
	fullJson := applied report llmJsonObject.
	self assert: ((fullJson at: 'methodChanges') at: 'displayedCount') equals: 5.
	self
		assert: (((fullJson at: 'methodChanges') at: 'methods')
				noneSatisfy: [ :each | each includesKey: 'newSource' ]) ]
		ensure: [ self removeFixtures ].
	^ applyCall
]

{ #category : #examples }
GtLMagritteToolForClassRenameExamples >> previewOfSnippetChangeNestedInRename [
	"The Lepiter changes of a class rename are nested in its RB change. The snippet is in memory, so the change is added explicitly and the preview is not applied"

	<gtExample>
	| transformations namespace aRenameChange aPage aSnippet preview lepiterChanges anEntry json |
	[ self installClassFixtures.
	transformations := GtLCodeTransformations new
			transformations: {GtLRenameClassSpecification new
						className: self targetName;
						newClassName: self renamedTargetName;
						yourself}.
	namespace := transformations applyRefactoring.
	namespace changes
		gtAllChangesDo: [ :each | (each isKindOf: RBRenameClassChange) ifTrue: [ aRenameChange := each ] ].
	self assert: aRenameChange notNil.
	aPage := LePage named: 'Using the target'.
	LeDatabase new addPage: aPage.
	aSnippet := LePharoSnippet code: self targetName , ' new'.
	aPage addSnippet: aSnippet.
	aRenameChange
		addChange: (LeSnippetChange new
				snippet: aSnippet;
				newSource: self renamedTargetName , ' new';
				yourself).
	preview := GtLRefactoringPreview
			namespace: namespace
			refactoringName: transformations refactoringName
			refactoringDescription: transformations refactoringDescription
			changeGroupNames: transformations changeGroupNames.
	lepiterChanges := preview report changeGroups lepiterChanges.
	self assert: lepiterChanges totalSnippetsCount equals: 1.
	self
		assert: lepiterChanges displayedDatabaseReports first displayedPageReports first
				pageTitle
		equals: 'Using the target'.
	anEntry := lepiterChanges displayedDatabaseReports first displayedPageReports
			first displayedEntries first.
	self assert: anEntry kind equals: 'modified snippet'.
	self assert: anEntry snippetUid equals: aSnippet uid uidString.
	self assert: anEntry newSource equals: self renamedTargetName , ' new'.
	json := preview report llmJsonObject.
	self assert: (json includesKey: 'lepiterChanges').
	self assert: preview changesCount equals: 8.
	self assert: (self classNamed: self targetName) notNil ]
		ensure: [ self removeFixtures ].
	^ preview
]

{ #category : #fixtures }
GtLMagritteToolForClassRenameExamples >> referencerDummy [
	^ self dummyPackagesInOrder second dummyClasses first
]

{ #category : #fixtures }
GtLMagritteToolForClassRenameExamples >> referencerName [
	^ self referencerDummy className asString
]

{ #category : #examples }
GtLMagritteToolForClassRenameExamples >> refuseInvalidLimit [
	"The JSON schema refuses a negative limit before the tool runs"

	<gtExample>
	| call |
	call := self
			performRenameWith: (Dictionary new
					at: 'className' put: 'GtLClassRenameExamplesNoSuchClass';
					at: 'newClassName' put: 'GtLClassRenameExamplesNewName';
					at: 'displayOptions' put: {'snippetsLimit' -> -3} asDictionary;
					yourself).
	self
		assert: (self modelOf: call) errorMessage
		equals: '@[displayOptions/snippetsLimit] smaller than minimum [0]'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRenameExamples >> refuseRenameOfUnknownClass [
	<gtExample>
	| call |
	call := self
			performRenameWith: (Dictionary new
					at: 'className' put: 'GtLClassRenameExamplesNoSuchClass';
					at: 'newClassName' put: 'GtLClassRenameExamplesNewName';
					yourself).
	self
		assertProblem: (self modelOf: call)
		withErrorMessage: 'Class not found: GtLClassRenameExamplesNoSuchClass'.
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRenameExamples >> refuseRenameToUsedName [
	<gtExample>
	| call |
	[ self installClassFixtures.
	call := self
			performRenameWith: (self renameTargetArguments
					at: 'newClassName' put: self referencerName;
					yourself).
	self
		assertProblem: (self modelOf: call)
		withErrorMessage: self referencerName , ' is already the name of a class or global variable'.
	self assert: (self classNamed: self targetName) notNil ]
		ensure: [ self removeFixtures ].
	^ call
]

{ #category : #fixtures }
GtLMagritteToolForClassRenameExamples >> removeFixtures [
	"Remove the temporary classes and packages, also after a rename, out of the global undo/redo history"

	dummies ifNil: [ ^ self ].
	GtRefactoryChangeManager
		isolatedInstanceDuring: [ self removeDummies: dummies ].
	dummies := nil
]

{ #category : #examples }
GtLMagritteToolForClassRenameExamples >> renameClassResponse [
	"The response lists the groups of applied changes, within the limits and without sources.
	The 7 changes are the rename, the definition of the subclass and 5 methods. No snippet uses the fixtures: lepiterChanges is empty"

	<gtExample>
	| call json |
	[ self installClassFixtures.
	call := self
			performRenameWith: (self renameTargetArguments
					at: 'displayOptions'
						put: {'includeSources' -> false.
								'methodsLimit' -> 2} asDictionary;
					yourself).
	json := self jsonOf: call.
	self assert: (json at: 'status') equals: 'applied'.
	self assert: (json at: 'changesCount') equals: 7.
	self assert: (json includesKey: 'codeChanges') not.
	self assert: ((json at: 'lepiterChanges') at: 'totalSnippetsCount') equals: 0.
	self assert: (json includesKey: 'displayOptions') not.
	self assert: ((json at: 'classChanges') at: 'totalCount') equals: 2.
	self assert: ((json at: 'methodChanges') at: 'totalCount') equals: 5.
	self assert: ((json at: 'methodChanges') at: 'displayedCount') equals: 2.
	self assert: ((json at: 'methodChanges') at: 'methods') size equals: 2.
	self
		assert: (((json at: 'methodChanges') at: 'methods')
				noneSatisfy: [ :each | each includesKey: 'newSource' ]).
	self
		assert: (((json at: 'methodChanges') at: 'methods') first at: 'methodClassName')
		equals: self renamedTargetName.
	self
		assert: (((json at: 'classChanges') at: 'classes') first at: 'newClassName')
		equals: self renamedTargetName ] ensure: [ self removeFixtures ].
	^ json
]

{ #category : #examples }
GtLMagritteToolForClassRenameExamples >> renameClassResponseWithoutChanges [
	"Without the changes, the response tells the status and the objectId of the stored result. The result keeps all the applied changes; there is no errorMessage when the rename succeeded"

	<gtExample>
	| call json result fullJson |
	[ self installClassFixtures.
	call := self
			performRenameWith: (self renameTargetArguments
					at: 'displayOptions' put: {'includeChanges' -> false} asDictionary;
					yourself).
	json := self jsonOf: call.
	self
		assert: json keys asSet
		equals: #('status' 'refactoringName' 'refactoringDescription' 'changesCount' 'objectId')
				asSet.
	self assert: (json at: 'status') equals: 'applied'.
	result := self objectStorage objectAt: (json at: 'objectId').
	self assert: result class equals: GtLRefactoringResult.
	self assert: result == (self modelOf: call).
	self assert: result preview isApplied.
	fullJson := result report llmJsonObject.
	self assert: (fullJson at: 'status') equals: 'applied'.
	self assert: ((fullJson at: 'classChanges') at: 'totalCount') equals: 2.
	self assert: ((fullJson at: 'methodChanges') at: 'totalCount') equals: 5.
	self assert: ((fullJson at: 'methodChanges') at: 'methods') size equals: 5.
	self assert: (self classNamed: self renamedTargetName) notNil ]
		ensure: [ self removeFixtures ].
	^ json
]

{ #category : #examples }
GtLMagritteToolForClassRenameExamples >> renameClassWithReferences [
	"The class is renamed, its references are rewritten, also as symbols, and its subclass is reported as a changed class: its definition names the class"

	<gtExample>
	| call result groups aTarget |
	[ aTarget := self installClassFixtures.
	call := self performRenameWith: self renameTargetArguments.
	result := self modelOf: call.
	self assert: result class equals: GtLRefactoringResult.
	self assert: result groupsChanges.
	self assert: result status equals: 'applied'.
	self assert: result refactoringName equals: 'Rename class'.
	self
		assert: result refactoringDescription
		equals: 'Rename class ' , self targetName , ' to ' , self renamedTargetName.
	self assert: aTarget name asString equals: self renamedTargetName.
	self assert: (self classNamed: self targetName) isNil.
	self assert: (self classNamed: self subclassName) superclass == aTarget.
	self
		assert: ((aTarget >> #itself) sourceCode includesSubstring: self renamedTargetName).
	self
		assert: (((self classNamed: self referencerName) >> #targetName) sourceCode
				includesSubstring: '#' , self renamedTargetName).
	groups := result report changeGroups.
	self
		assert: (groups classChanges displayedEntries
				collect: [ :each | each kind -> each target ]) asArray
		equals: {'renamed class'
					-> (self targetName , ' to ' , self renamedTargetName).
				'changed class' -> self subclassName}.
	self
		assert: (groups methodChanges displayedEntries collect: [ :each | each target ]) asArray
		equals: self expectedMethodTargets.
	self
		assert: (groups methodChanges displayedEntries
				allSatisfy: [ :each | each kind = 'modified method' ]).
	self assert: groups lepiterChanges isEmpty ] ensure: [ self removeFixtures ].
	^ call
]

{ #category : #private }
GtLMagritteToolForClassRenameExamples >> renameTargetArguments [
	^ Dictionary new
		at: 'className' put: self targetName;
		at: 'newClassName' put: self renamedTargetName;
		yourself
]

{ #category : #examples }
GtLMagritteToolForClassRenameExamples >> renameUsedTrait [
	"The users keep the renamed trait in their composition and are reported as changed classes"

	<gtExample>
	| call result groups aTrait aUser |
	[ aTrait := self installTraitFixtures.
	aUser := self classNamed: self traitUserName.
	call := self
			performRenameWith: (Dictionary new
					at: 'className' put: self traitName;
					at: 'newClassName' put: self renamedTraitName;
					yourself).
	result := self modelOf: call.
	self assert: result status equals: 'applied'.
	self assert: aTrait name asString equals: self renamedTraitName.
	self assert: (aUser traitComposition includesTrait: aTrait).
	self assert: aUser traitComposition printString equals: self renamedTraitName.
	self
		assert: ((aTrait >> #traitMethod) sourceCode includesSubstring: self renamedTraitName).
	self
		assert: ((aUser >> #traitMethod) sourceCode includesSubstring: self renamedTraitName).
	groups := result report changeGroups.
	self
		assert: (groups classChanges displayedEntries
				collect: [ :each | each kind -> each target ]) asArray
		equals: {'renamed class' -> (self traitName , ' to ' , self renamedTraitName).
				'changed class' -> self traitUserName}.
	self
		assert: (groups methodChanges displayedEntries collect: [ :each | each target ]) asArray
		equals: {self renamedTraitName , '>>#traitMethod'} ]
		ensure: [ self removeFixtures ].
	^ call
]

{ #category : #examples }
GtLMagritteToolForClassRenameExamples >> renameWithRemovedMethodResponse [
	"One previewRefactoring call removes a method and renames its class, the removal first. The removed method is listed under the new class name, in the preview and once applied; changesCount is the sum of the group totals"

	<gtExample>
	| previewCall json applyCall appliedJson removedMethod |
	[ self installClassFixtures.
	previewCall := self
			performTool: GtLToolForPreviewRefactoring new
			withArguments: (Dictionary new
					at: 'transformations'
						put: {Dictionary new
									at: 'RemoveMethod'
										put: (Dictionary new
												at: 'methodClassName' put: self targetName;
												at: 'classSide' put: false;
												at: 'methodNameToRemove' put: 'itself';
												yourself);
									yourself.
								Dictionary new
									at: 'RenameClass' put: self renameTargetArguments;
									yourself};
					yourself).
	json := self jsonOf: previewCall.
	removedMethod := [ :aJson | 
		((aJson at: 'methodChanges') at: 'methods')
			detect: [ :each | (each at: 'kind') = 'removed method' ] ].
	self
		assert: ((removedMethod value: json) at: 'methodClassName')
		equals: self renamedTargetName.
	self
		assert: (json at: 'changesCount')
		equals: ((json at: 'classChanges') at: 'totalCount')
				+ ((json at: 'methodChanges') at: 'totalCount')
				+ ((json at: 'lepiterChanges') at: 'totalSnippetsCount').
	applyCall := self
			performTool: GtLToolForApplyRefactoring new
			withArguments: (Dictionary new
					at: 'objectId' put: (json at: 'objectId');
					yourself).
	appliedJson := self jsonOf: applyCall.
	self assert: (appliedJson at: 'status') equals: 'applied'.
	self
		assert: ((removedMethod value: appliedJson) at: 'methodClassName')
		equals: self renamedTargetName.
	self
		assert: ((self classNamed: self renamedTargetName) includesSelector: #itself) not ]
		ensure: [ self removeFixtures ].
	^ appliedJson
]

{ #category : #fixtures }
GtLMagritteToolForClassRenameExamples >> renamedTargetName [
	^ self targetName , 'Renamed'
]

{ #category : #fixtures }
GtLMagritteToolForClassRenameExamples >> renamedTraitName [
	^ self traitName , 'Renamed'
]

{ #category : #fixtures }
GtLMagritteToolForClassRenameExamples >> subclassDummy [
	^ self dummyPackagesInOrder first dummyClasses second
]

{ #category : #fixtures }
GtLMagritteToolForClassRenameExamples >> subclassName [
	^ self subclassDummy className asString
]

{ #category : #examples }
GtLMagritteToolForClassRenameExamples >> summaryOfRenamedClass [
	"In the summary, a rename removes the class under its old name and adds it under its new name"

	<gtExample>
	| call aGroup summarizer histories oldHistory newHistory subclassHistory |
	[ self installClassFixtures.
	call := self performRenameWith: self renameTargetArguments.
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
		assert: (summarizer codeChanges collect: [ :each | each label ]) asSet
		equals: #('Refactoring (Rename class): renamed class' 'Refactoring (Rename class): changed class' 'Refactoring (Rename class): modified method')
				asSet.
	histories := summarizer classChangeHistories.
	oldHistory := histories
			detect: [ :each | each targetClassName asString = self targetName ].
	newHistory := histories
			detect: [ :each | each targetClassName asString = self renamedTargetName ].
	subclassHistory := histories
			detect: [ :each | each targetClassName asString = self subclassName ].
	self assert: oldHistory isLatestDefinitionChangeRemoval.
	self assert: oldHistory isInitialDefinitionChangeAddition not.
	self assert: newHistory isInitialDefinitionChangeAddition.
	self assert: newHistory isLatestDefinitionChangeRemoval not.
	self assert: oldHistory behaviourChanges size equals: 1.
	self
		assert: oldHistory behaviourChanges first changeResult
				== newHistory behaviourChanges first changeResult.
	self assert: subclassHistory isInitialDefinitionChangeAddition not.
	self assert: subclassHistory isLatestDefinitionChangeRemoval not ]
		ensure: [ self removeFixtures ].
	^ summarizer
]

{ #category : #fixtures }
GtLMagritteToolForClassRenameExamples >> targetDummy [
	^ self dummyPackagesInOrder first dummyClasses first
]

{ #category : #fixtures }
GtLMagritteToolForClassRenameExamples >> targetName [
	"The name of the target before the rename"

	^ self targetDummy className asString
]

{ #category : #fixtures }
GtLMagritteToolForClassRenameExamples >> traitName [
	^ 'T' , self targetName
]

{ #category : #fixtures }
GtLMagritteToolForClassRenameExamples >> traitUserName [
	^ self targetName , 'TraitUser'
]

{ #category : #examples }
GtLMagritteToolForClassRenameExamples >> undoRenameClass [
	<gtExample>
	| call aTarget |
	[ aTarget := self installClassFixtures.
	call := self performRenameWith: self renameTargetArguments.
	GtRefactoryChangeManager
		isolatedInstanceDuring: [ (self modelOf: call) undoChange execute ].
	self assert: aTarget name asString equals: self targetName.
	self assert: (self classNamed: self targetName) == aTarget.
	self assert: (self classNamed: self renamedTargetName) isNil.
	self
		assert: (aTarget >> #itself) sourceCode
		equals: 'itself ^ ' , self targetName.
	self
		assert: ((self classNamed: self referencerName) >> #targetName) sourceCode
		equals: 'targetName ^ #' , self targetName ] ensure: [ self removeFixtures ].
	^ call
]
