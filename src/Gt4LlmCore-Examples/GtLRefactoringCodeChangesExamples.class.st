"
I show how applying a refactoring through {{gtClass:GtLRefactoringPreview}} produces {{gtClass:GtLCodeChangeResult}} objects (see {{gtClass:GtLRefactoringCodeChangesBuilder}}) and how the {{gtClass:GtLCodeChangesToolCallsSummarizer}} summarizes them.

Each example works on temporary dummy classes (see {{gtClass:GtPharoDummiesGenerator}}) that are removed afterwards, and runs inside {{gtMethod:GtRefactoryChangeManager class>>#isolatedInstanceDuring:}} so that it does not affect the global undo history.
"
Class {
	#name : #GtLRefactoringCodeChangesExamples,
	#superclass : #GtLToolCallsSummarizerExamplesBase,
	#category : #'Gt4LlmCore-Examples-Refactorings'
}

{ #category : #private }
GtLRefactoringCodeChangesExamples >> applyNamespace: aNamespace [
	^ (GtLRefactoringPreview namespace: aNamespace)
		objectId: 'example-object-id';
		apply
]

{ #category : #examples }
GtLRefactoringCodeChangesExamples >> classChangesShareTheCodeChangeOfTheirClass [
	"Several class-level changes of one class lead to a single code change result for the class:
	a modification when the definition changes (it includes the comment), and a comment change otherwise.
	Each class-level change, including a comment change, is linked to that result"

	<gtExample>
	^ self
		withDummyHierarchyDo: [ :aRootClass :aLeafClass | 
			| aNamespace aPreview anAppliedRefactoring aCommentPreview aCommentApplied |
			"A comment change and a slot addition on the same class"
			aNamespace := GtRBNamespace new.
			(aNamespace classFor: aRootClass) comment: 'A changed comment'.
			(aNamespace classFor: aRootClass) addInstanceVariable: 'addedSlot'.
			aPreview := (GtLRefactoringPreview namespace: aNamespace)
					objectId: 'example-object-id';
					yourself.
			anAppliedRefactoring := aPreview apply.
			self assert: anAppliedRefactoring status equals: 'applied'.
			self assert: anAppliedRefactoring codeChangeResults size equals: 1.
			self
				assert: anAppliedRefactoring codeChangeResults first class
				equals: GtLClassModificationResult.
			self
				assert: (aPreview changes collect: [ :each | each kind ]) asSet
				equals: #('changed class comment' 'added slot') asSet.
			self
				assert: (aPreview changes
						allSatisfy: [ :each | each codeChangeResult == anAppliedRefactoring codeChangeResults first ]).	"A comment change alone"
			aNamespace := GtRBNamespace new.
			(aNamespace classFor: aLeafClass) comment: 'Another changed comment'.
			aCommentPreview := (GtLRefactoringPreview namespace: aNamespace)
					objectId: 'example-object-id';
					yourself.
			aCommentApplied := aCommentPreview apply.
			self assert: aCommentApplied codeChangeResults size equals: 1.
			self
				assert: aCommentApplied codeChangeResults first class
				equals: GtLClassCommentChangeResult.
			self assert: aCommentPreview changes size equals: 1.
			self
				assert: aCommentPreview changes first codeChangeResult
						== aCommentApplied codeChangeResults first.
			aPreview ]
]

{ #category : #'examples - refactorings' }
GtLRefactoringCodeChangesExamples >> failedRefactoringReportsAppliedChanges [
	"When a change fails, the applied refactoring is marked as failed,
	holds the frozen exception and describes the changes applied before the error"

	<gtExample>
	^ self
		withDummyHierarchyDo: [ :aRootClass :aLeafClass | 
			| anOtherEnvironment anOtherClass aNamespace anAppliedRefactoring anAddition |
			anOtherEnvironment := GtPharoDummiesGenerator
					withPackages: 1
					classHierarchy: 1.
			[ anOtherClass := anOtherEnvironment anyDummyLeafClass realClass.
			aNamespace := GtRBNamespace new.
			(aNamespace classFor: aLeafClass)
				compile: 'appliedBeforeError ^ 1'
				classified: #examples.
			(aNamespace classFor: anOtherClass)
				compile: 'failingMethod ^ 2'
				classified: #examples ] ensure: [ anOtherEnvironment removeFromSystem ].

			anAppliedRefactoring := self applyNamespace: aNamespace.

			self assert: anAppliedRefactoring status equals: 'failed'.
			self assert: anAppliedRefactoring hasFailed.
			self assert: anAppliedRefactoring undoChange isNil.
			self assert: anAppliedRefactoring preview isApplied not.
			self assert: anAppliedRefactoring exception isErrorDomainObject.
			self assert: anAppliedRefactoring errorMessage notNil.
			self assert: (aLeafClass includesSelector: #appliedBeforeError).

			self assert: anAppliedRefactoring codeChangeResults size equals: 1.
			anAddition := anAppliedRefactoring codeChangeResults first.
			self assert: anAddition isMethodAdditionResult.
			self
				assert: anAddition targetMethodReference methodSignature
				equals: aLeafClass name , '>>#appliedBeforeError'.
			anAppliedRefactoring ]
]

{ #category : #'examples - refactorings' }
GtLRefactoringCodeChangesExamples >> pushUpInstanceVariable [
	"Pushing up an instance variable changes the definitions of both classes"

	<gtExample>
	^ self
		withDummyHierarchyDo: [ :aRootClass :aLeafClass | 
			| aNamespace anAppliedRefactoring aRootResult aLeafResult |
			aNamespace := GtLPushUpInstanceVariableSpecification new
					variableClassName: aRootClass name;
					variableName: 'instVar3';
					namespaceWithAppliedRefactoring.
			anAppliedRefactoring := self applyNamespace: aNamespace.

			self assert: anAppliedRefactoring status equals: 'applied'.
			self assert: (aRootClass instVarNames includes: #instVar3).
			self assert: (aLeafClass instVarNames includes: #instVar3) not.

			self
				assert: (anAppliedRefactoring codeChangeResults
						allSatisfy: [ :each | each class = GtLClassModificationResult ]).
			aRootResult := anAppliedRefactoring codeChangeResults
					detect: [ :each | each targetClassName = aRootClass name ].
			self assert: aRootResult isClassModificationResult.
			self
				assert: (aRootResult originalClass instanceSlotNames includes: #instVar3) not.
			self assert: (aRootResult updatedClass instanceSlotNames includes: #instVar3).
			aLeafResult := anAppliedRefactoring codeChangeResults
					detect: [ :each | each targetClassName = aLeafClass name ].
			self
				assert: (aLeafResult originalClass instanceSlotNames includes: #instVar3).
			self
				assert: (aLeafResult updatedClass instanceSlotNames includes: #instVar3) not.
			anAppliedRefactoring ]
]

{ #category : #'examples - refactorings' }
GtLRefactoringCodeChangesExamples >> pushUpMethod [
	"Pushing up a method adds it to the superclass and removes it from the subclass"

	<gtExample>
	^ self
		withDummyHierarchyDo: [ :aRootClass :aLeafClass | 
			| aNamespace anAppliedRefactoring anAddition aRemoval |
			aLeafClass compile: 'pushedUpMethod ^ 42' classified: #examples.
			aNamespace := GtLPushUpMethodSpecification new
					methodNameToPushUp: #pushedUpMethod;
					methodClassName: aLeafClass name;
					targetClassName: aRootClass name;
					namespaceWithAppliedRefactoring.
			anAppliedRefactoring := self applyNamespace: aNamespace.

			self assert: anAppliedRefactoring status equals: 'applied'.
			self assert: anAppliedRefactoring undoChange notNil.
			self assert: anAppliedRefactoring preview isApplied.
			self assert: anAppliedRefactoring codeChangeResults size equals: 2.

			anAddition := anAppliedRefactoring codeChangeResults first.
			self assert: anAddition class equals: GtLMethodCompilationResult.
			self assert: anAddition isMethodAdditionResult.
			self
				assert: anAddition targetMethodReference methodClassName
				equals: aRootClass name asString.
			self assert: anAddition newMethod sourceCode equals: 'pushedUpMethod ^ 42'.
			self assert: anAddition affectedPackageName equals: aRootClass package name.

			aRemoval := anAppliedRefactoring codeChangeResults second.
			self assert: aRemoval class equals: GtLMethodRemovalResult.
			self
				assert: aRemoval targetMethodReference methodClassName
				equals: aLeafClass name asString.
			self assert: aRemoval removedMethod sourceCode equals: 'pushedUpMethod ^ 42'.

			self
				assert: anAppliedRefactoring codeChanges asArray
				equals: {'added method ' , aRootClass name , '>>#pushedUpMethod'.
						'removed method ' , aLeafClass name , '>>#pushedUpMethod'}.
			anAppliedRefactoring ]
]

{ #category : #examples }
GtLRefactoringCodeChangesExamples >> refactoringChangesAreLinkedToCodeChanges [
	"Once applied, each refactoring change is linked to the code change result it led to.
	Before applying, its diff is the one of the RB change against the current image;
	once applied, that view is replaced by the applied diff of the code change result, which says so explicitly"

	<gtExample>
	^ self
		withDummyHierarchyDo: [ :aRootClass :aLeafClass | 
			| aNamespace aPreview anAppliedRefactoring aSlotRemoval aSlotAddition |
			aNamespace := GtLPushUpInstanceVariableSpecification new
					variableClassName: aRootClass name;
					variableName: 'instVar3';
					namespaceWithAppliedRefactoring.
			aPreview := (GtLRefactoringPreview namespace: aNamespace)
					objectId: 'example-object-id';
					yourself.
			self assert: (aPreview changes allSatisfy: [ :each | each isApplied not ]).
			self
				assert: (aPreview changes allSatisfy: [ :each | each codeChangeResult isNil ]).
			self
				assert: aPreview printString
				equals: 'a GtLRefactoringPreview(' , aPreview changesCount printString
						, ' changes, not applied)'.
			aSlotRemoval := aPreview changes
					detect: [ :each | each kind = 'removed slot' ].	"Before applying: only the diff with the current image"
			self
				assert: (aSlotRemoval gtDiffFor: GtPhlowEmptyView new) title asString
				equals: 'Diff (with current image)'.
			self
				assert: ((aSlotRemoval gtAppliedDiffFor: GtPhlowEmptyView new)
						isKindOf: GtPhlowEmptyView).

			anAppliedRefactoring := aPreview apply.
			self assert: anAppliedRefactoring status equals: 'applied'.
			self
				assert: aPreview printString
				equals: 'a GtLRefactoringPreview(' , aPreview changesCount printString
						, ' changes, applied)'.
			self assert: (aPreview changes allSatisfy: [ :each | each isApplied ]).
			self assert: aSlotRemoval target equals: aLeafClass name asString.
			self
				assert: (anAppliedRefactoring codeChangeResults
						identityIncludes: aSlotRemoval codeChangeResult).
			self
				assert: aSlotRemoval codeChangeResult targetClassName
				equals: aLeafClass name.
			aSlotAddition := aPreview changes
					detect: [ :each | each kind = 'added slot' ].
			self
				assert: aSlotAddition codeChangeResult targetClassName
				equals: aRootClass name.	"After applying: only the applied diff, which says it shows the whole code change of the class"
			self
				assert: ((aSlotRemoval gtDiffFor: GtPhlowEmptyView new) isKindOf: GtPhlowEmptyView).
			self
				assert: (aSlotRemoval gtAppliedDiffFor: GtPhlowEmptyView new) title asString
				equals: 'Applied diff'.
			self
				assert: aSlotRemoval appliedDiffNote
				equals: 'Applied: the code change recorded for ' , aLeafClass name
						, ' when the refactoring was applied. It shows everything the refactoring changed in '
						, aLeafClass name , ', which can be more than this change.'.
			self
				assert: (aSlotRemoval
						diffElementWithNote: aSlotRemoval appliedDiffNote
						diffElement: aSlotRemoval codeChangeResult asDiffElement) notNil.
			aPreview ]
]

{ #category : #'examples - refactorings' }
GtLRefactoringCodeChangesExamples >> removeClass [
	"Removing a class reports the class removal and the removal of all its methods, on both sides"

	<gtExample>
	^ self
		withDummyHierarchyDo: [ :aRootClass :aLeafClass | 
			| aLeafName aSelectors aClassSideSelectors aNamespace anAppliedRefactoring aMethodRemovals aClassRemovals |
			aLeafName := aLeafClass name asString.
			aSelectors := aLeafClass localSelectors asSet.
			aClassSideSelectors := aLeafClass classSide localSelectors asSet.
			aNamespace := GtRBNamespace new.
			aNamespace removeClassNamed: aLeafClass name.
			anAppliedRefactoring := self applyNamespace: aNamespace.

			self assert: anAppliedRefactoring status equals: 'applied'.
			self assert: (Smalltalk globals includesKey: aLeafName asSymbol) not.

			aClassRemovals := self
					resultsOf: anAppliedRefactoring
					ofKind: 'removed class'.
			self assert: aClassRemovals size equals: 1.
			self assert: aClassRemovals first removedClassName equals: aLeafName.
			self
				assert: anAppliedRefactoring codeChangeResults last == aClassRemovals first
				description: 'Class removals come after the method removals'.

			aMethodRemovals := self
					resultsOf: anAppliedRefactoring
					ofKind: 'removed method'.
			self
				assert: aMethodRemovals size
				equals: aSelectors size + aClassSideSelectors size.
			self
				assert: ((aMethodRemovals reject: [ :each | each targetMethodReference isClassSide ])
						collect: [ :each | each targetMethodReference methodName asSymbol ]) asSet
				equals: aSelectors.
			self
				assert: ((aMethodRemovals select: [ :each | each targetMethodReference isClassSide ])
						collect: [ :each | each targetMethodReference methodName asSymbol ]) asSet
				equals: aClassSideSelectors.
			anAppliedRefactoring ]
]

{ #category : #'examples - refactorings' }
GtLRefactoringCodeChangesExamples >> renameClass [
	"Renaming a class is a single class modification plus the rewritten references;
	the methods of the renamed class are not reported as removed and added"

	<gtExample>
	^ self
		withDummyHierarchyDo: [ :aRootClass :aLeafClass | 
			| anOldName aNewName aNamespace anAppliedRefactoring aRename aReference |
			anOldName := aLeafClass name.
			aNewName := (anOldName , 'Renamed') asSymbol.
			aRootClass compile: 'leafClass ^ ' , anOldName classified: #examples.
			aNamespace := GtRBNamespace new.
			(GtRBRenameClassRefactoring
				model: aNamespace
				rename: anOldName
				to: aNewName) primitiveExecute.
			anAppliedRefactoring := self applyNamespace: aNamespace.

			self assert: anAppliedRefactoring status equals: 'applied'.
			self assert: aLeafClass name equals: aNewName.
			self assert: anAppliedRefactoring codeChangeResults size equals: 2.

			aRename := anAppliedRefactoring codeChangeResults first.
			self assert: aRename class equals: GtLClassModificationResult.
			self assert: aRename originalClass currentClassName equals: anOldName.
			self assert: aRename updatedClass currentClassName equals: aNewName.
			self
				assert: (anAppliedRefactoring kindOfCodeChange: aRename)
				equals: 'renamed class'.

			aReference := anAppliedRefactoring codeChangeResults second.
			self assert: aReference class equals: GtLMethodCompilationResult.
			self assert: aReference isMethodModificationResult.
			self
				assert: aReference oldMethod sourceCode
				equals: 'leafClass ^ ' , anOldName.
			self
				assert: aReference newMethod sourceCode
				equals: 'leafClass ^ ' , aNewName.

			self
				assert: anAppliedRefactoring codeChanges first
				equals: 'renamed class ' , anOldName , ' to ' , aNewName.
			anAppliedRefactoring ]
]

{ #category : #private }
GtLRefactoringCodeChangesExamples >> resultsOf: anAppliedRefactoring ofKind: aKindString [
	^ anAppliedRefactoring codeChangeResults
		select: [ :each | (anAppliedRefactoring kindOfCodeChange: each) = aKindString ]
]

{ #category : #'examples - summarizer' }
GtLRefactoringCodeChangesExamples >> summarizerWithAppliedRefactoring [
	"An applyRefactoring tool call is summarized through the code change results of the applied refactoring"

	<gtExample>
	^ self
		withDummyHierarchyDo: [ :aRootClass :aLeafClass | 
			| aNamespace anObjectStorage anObjectId aToolCall aGroup aSummarizer aPackageHistories |
			aLeafClass compile: 'pushedUpMethod ^ 42' classified: #examples.
			aNamespace := GtLPushUpMethodSpecification new
					methodNameToPushUp: #pushedUpMethod;
					methodClassName: aLeafClass name;
					targetClassName: aRootClass name;
					namespaceWithAppliedRefactoring.
			anObjectStorage := GtLObjectStorage new.
			anObjectId := anObjectStorage
					addNewObject: (GtLRefactoringPreview namespace: aNamespace)
					reason: 'example preview'.
			aToolCall := GtLFunctionToolCall new
					name: GtLToolForApplyRefactoring new name;
					rawArguments: (Dictionary new
							at: 'objectId' put: anObjectId;
							yourself);
					yourself.
			GtLToolForApplyRefactoring new
				performToolCall: aToolCall
				inContext: (GtLToolExecutionContext new objectStorage: anObjectStorage).
			self assert: aToolCall result model class equals: GtLAppliedRefactoring.

			aGroup := GtLMessagesGroup new.
			aGroup add: (self toolMessageFrom: aToolCall).
			aSummarizer := aGroup toolCallsSummarizers
					detect: [ :each | each class = GtLCodeChangesToolCallsSummarizer ].
			self assert: aSummarizer relevantToolCalls size equals: 1.
			self assert: aSummarizer codeChanges size equals: 2.
			self
				assert: (aSummarizer codeChanges collect: [ :each | each label ]) asArray
				equals: #('Refactoring: added method' 'Refactoring: removed method').
			self assert: aSummarizer methodChangeHistories size equals: 2.
			self assert: aSummarizer classChangeHistories size equals: 2.
			aPackageHistories := aSummarizer packageChangeHistories.
			self assert: aPackageHistories size equals: 1.
			self
				assert: aSummarizer summaryText
				equals: '2 code changes from 1 tool calls'.
			aSummarizer ]
]

{ #category : #'examples - refactorings' }
GtLRefactoringCodeChangesExamples >> undoRestoresSnapshotBeforeChanges [
	"Executing the undo change answered by the change manager restores the state snapshotted before the changes:
	comparing that snapshot with a new one finds no code changes"

	<gtExample>
	^ self
		withDummyHierarchyDo: [ :aRootClass :aLeafClass | 
			| aNamespace aChange aTargets aBefore anUndoChange anAfter aRestored |
			aLeafClass compile: 'pushedUpMethod ^ 42' classified: #examples.
			aNamespace := GtLPushUpMethodSpecification new
					methodNameToPushUp: #pushedUpMethod;
					methodClassName: aLeafClass name;
					targetClassName: aRootClass name;
					namespaceWithAppliedRefactoring.
			aChange := aNamespace changes.
			aTargets := GtLRefactoringChangeTargets forChange: aChange.
			aBefore := aTargets snapshotBeforeChanges.
			anUndoChange := GtRefactoryChangeManager instance
					performChangeReturningUndo: aChange.
			anAfter := aTargets snapshotAfterChanges.
			self
				assert: (GtLRefactoringCodeChangesBuilder
						targets: aTargets
						before: aBefore
						after: anAfter) build size
				equals: 2.

			GtRefactoryChangeManager instance undoChange.
			aRestored := aTargets snapshotAfterChanges.
			self assert: (aLeafClass includesSelector: #pushedUpMethod).
			self assert: (aRootClass includesSelector: #pushedUpMethod) not.
			self
				assert: (GtLRefactoringCodeChangesBuilder
						targets: aTargets
						before: aBefore
						after: aRestored) build isEmpty.
			anUndoChange ]
]
