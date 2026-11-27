"
I compare a snapshot taken before applying a refactoring with one taken after applying it and build the corresponding code change results ({{gtClass:GtLCodeChangeResult}} subclasses):
- a method that appears is a {{gtClass:GtLMethodCompilationResult}} without old method;
- a method whose source changed is a {{gtClass:GtLMethodCompilationResult}} with the old method;
- a method that disappears is a {{gtClass:GtLMethodRemovalResult}};
- a class that appears is a {{gtClass:GtLClassModificationResult}} without original class;
- a class whose definition changed (including a rename or a package move) is a {{gtClass:GtLClassModificationResult}};
- a class whose comment alone changed is a {{gtClass:GtLClassCommentChangeResult}};
- a class that disappears is a {{gtClass:GtLClassRemovalResult}}.

These are the same objects that the other code changing tools produce, so the {{gtClass:GtLCodeChangesToolCallsSummarizer}} handles them without knowing about refactorings.

{{gtMethod:GtLRefactoringCodeChangesBuilder>>#buildLepiterChangeResults}} builds the Lepiter snippet change results in the same way (a snippet that appears is a {{gtClass:GtLLepiterSnippetAdditionResult}}, one whose content changed a {{gtClass:GtLLepiterSnippetModificationResult}}, one that disappears a {{gtClass:GtLLepiterSnippetRemovalResult}}), and keeps them by live snippet so that each Le change is linked to the result of its own snippet.
"
Class {
	#name : #GtLRefactoringCodeChangesBuilder,
	#superclass : #Object,
	#instVars : [
		'targets',
		'before',
		'after',
		'lepiterResults'
	],
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #'instance creation' }
GtLRefactoringCodeChangesBuilder class >> targets: aChangeTargets before: aBeforeSnapshot after: anAfterSnapshot [
	^ self new
		initializeTargets: aChangeTargets
		before: aBeforeSnapshot
		after: anAfterSnapshot
]

{ #category : #accessing }
GtLRefactoringCodeChangesBuilder >> after [
	^ after
]

{ #category : #accessing }
GtLRefactoringCodeChangesBuilder >> before [
	^ before
]

{ #category : #building }
GtLRefactoringCodeChangesBuilder >> build [
	"Return the code change results, ordered as: class additions and modifications,
	method changes, class removals"

	| classResults methodResults removalResults |
	classResults := OrderedCollection new.
	removalResults := OrderedCollection new.
	targets classNames
		do: [ :eachClassName | 
			(self classChangeResultFor: eachClassName)
				ifNotNil: [ :aResult | 
					aResult isClassRemovalResult
						ifTrue: [ removalResults add: aResult ]
						ifFalse: [ classResults add: aResult ] ] ].
	methodResults := targets methodReferences
			collect: [ :eachReference | self methodChangeResultFor: eachReference ]
			thenSelect: [ :each | each notNil ].
	^ (classResults , methodResults , removalResults) asArray
]

{ #category : #building }
GtLRefactoringCodeChangesBuilder >> buildLepiterChangeResults [
	"Return the Lepiter snippet change results, in the order of the snippets, and keep them by live snippet (identity) in #lepiterChangeResultsBySnippet.
	The result of a removed snippet holds the results of the descendants removed with it, depth first, each linked back to it"

	| results |
	lepiterResults := IdentityDictionary new.
	results := OrderedCollection new.
	targets snippets
		do: [ :eachSnippet | 
			(self lepiterChangeResultFor: eachSnippet)
				ifNotNil: [ :aResult | 
					lepiterResults at: eachSnippet put: aResult.
					results add: aResult ] ].
	targets snippets
		do: [ :eachSnippet | 
			(lepiterResults at: eachSnippet ifAbsent: [ nil ])
				ifNotNil: [ :aResult | 
					aResult isSnippetRemovalResult
						ifTrue: [ self linkDescendantsOf: eachSnippet to: aResult ] ] ].
	^ results asArray
]

{ #category : #building }
GtLRefactoringCodeChangesBuilder >> classChangeResultFor: aClassName [
	"Return a code change result for the class, or nil if the class did not change"

	| original updated |
	original := before classAt: aClassName.
	updated := after classAt: aClassName.
	(original isNil and: [ updated isNil ]) ifTrue: [ ^ nil ].
	original
		ifNil: [ ^ GtLClassModificationResult new
				originalClass: nil;
				updatedClass: updated;
				yourself ].
	updated
		ifNil: [ ^ GtLClassRemovalResult new
				removedClass: original;
				status: 'removed';
				yourself ].
	(self definitionKeyOf: original) = (self definitionKeyOf: updated)
		ifFalse: [ ^ GtLClassModificationResult new
				originalClass: original;
				updatedClass: updated;
				yourself ].
	original comment = updated comment
		ifFalse: [ ^ GtLClassCommentChangeResult new
				originalClass: original;
				updatedClass: updated;
				status: 'changed';
				yourself ].
	^ nil
]

{ #category : #private }
GtLRefactoringCodeChangesBuilder >> classDescriptionAfterFor: aMethodReference [
	^ (after classAt: aMethodReference methodClassName)
		ifNil: [ before classAt: aMethodReference methodClassName ]
]

{ #category : #private }
GtLRefactoringCodeChangesBuilder >> classDescriptionBeforeFor: aMethodReference [
	^ (before classAt: aMethodReference methodClassName)
		ifNil: [ after classAt: aMethodReference methodClassName ]
]

{ #category : #private }
GtLRefactoringCodeChangesBuilder >> definitionKeyOf: aClassDescription [
	"Return what identifies the definition of a class, without its comment: its definition string, which has the class-side slots and the package tag"

	^ aClassDescription asDefinitionString
]

{ #category : #initialization }
GtLRefactoringCodeChangesBuilder >> initializeTargets: aChangeTargets before: aBeforeSnapshot after: anAfterSnapshot [
	targets := aChangeTargets.
	before := aBeforeSnapshot.
	after := anAfterSnapshot
]

{ #category : #building }
GtLRefactoringCodeChangesBuilder >> lepiterChangeResultFor: aSnippet [
	"Return a Lepiter snippet change result for the snippet, or nil if it did not change"

	| oldSnippet newSnippet |
	oldSnippet := before snippetAt: aSnippet.
	newSnippet := after snippetAt: aSnippet.
	(oldSnippet isNil and: [ newSnippet isNil ]) ifTrue: [ ^ nil ].
	oldSnippet
		ifNil: [ ^ GtLLepiterSnippetAdditionResult new
				newSnippet: newSnippet;
				yourself ].
	newSnippet
		ifNil: [ ^ GtLLepiterSnippetRemovalResult new
				removedSnippet: oldSnippet;
				yourself ].
	oldSnippet content = newSnippet content ifTrue: [ ^ nil ].
	^ GtLLepiterSnippetModificationResult new
		oldSnippet: oldSnippet;
		newSnippet: newSnippet;
		yourself
]

{ #category : #accessing }
GtLRefactoringCodeChangesBuilder >> lepiterChangeResultsBySnippet [
	"Return the Lepiter results by live snippet (identity), once #buildLepiterChangeResults was called. They link each Le change to the result of its own snippet while applying"

	^ lepiterResults ifNil: [ IdentityDictionary new ]
]

{ #category : #building }
GtLRefactoringCodeChangesBuilder >> linkDescendantsOf: aSnippet to: aRemovalResult [
	"The descendants removed with aSnippet become the removedChildResults of its removal result, depth first, and each names it as removedWithSnippet"

	| theChildResults |
	theChildResults := OrderedCollection new.
	(targets descendantsRemovedWith: aSnippet)
		do: [ :each | 
			(lepiterResults at: each ifAbsent: [ nil ])
				ifNotNil: [ :aChildResult | 
					aChildResult isSnippetRemovalResult
						ifTrue: [ aChildResult removedWithSnippet: aRemovalResult targetSnippetReference.
							theChildResults add: aChildResult ] ] ].
	aRemovalResult removedChildResults: theChildResults
]

{ #category : #building }
GtLRefactoringCodeChangesBuilder >> methodChangeResultFor: aMethodReference [
	"Return a code change result for the method, or nil if the method did not change.
	A change of protocol alone is not reported."

	| oldMethod newMethod |
	oldMethod := before methodAt: aMethodReference.
	newMethod := after methodAt: aMethodReference.
	(oldMethod isNil and: [ newMethod isNil ]) ifTrue: [ ^ nil ].
	newMethod
		ifNil: [ ^ GtLMethodRemovalResult new
				targetClass: (self classDescriptionBeforeFor: aMethodReference);
				removedMethod: oldMethod;
				status: 'removed';
				yourself ].
	(oldMethod notNil and: [ oldMethod sourceCode = newMethod sourceCode ])
		ifTrue: [ ^ nil ].
	^ GtLMethodCompilationResult new
		targetClass: (self classDescriptionAfterFor: aMethodReference);
		oldMethod: oldMethod;
		newMethod: newMethod;
		status: 'compiled';
		yourself
]

{ #category : #accessing }
GtLRefactoringCodeChangesBuilder >> targets [
	^ targets
]
