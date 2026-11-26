"
I am the display options of the previewRewrite tool. A rewrite is reviewed through the new sources of the rewritten methods, so I include them by default.
"
Class {
	#name : #GtLRewriteDisplayOptions,
	#superclass : #GtLRefactoringDisplayOptions,
	#category : #'Gt4LlmCore-Refactorings'
}

{ #category : #accessing }
GtLRewriteDisplayOptions class >> defaultIncludeSources [
	"A rewrite is reviewed through the new sources of the rewritten methods"

	^ true
]

{ #category : #magritte }
GtLRewriteDisplayOptions >> classesLimitDescription [
	"A rewrite changes only methods"

	<magritteDescription>
	^ nil
]

{ #category : #descriptions }
GtLRewriteDisplayOptions >> descriptionContainer [
	^ super descriptionContainer
		comment: 'How much of the rewritten methods the response lists.';
		yourself
]

{ #category : #accessing }
GtLRewriteDisplayOptions >> displayOptionItems [
	"A rewrite lists only methods"

	^ {'includeSources' -> self includeSources.
		'methodsLimit' -> self methodsLimit}
]

{ #category : #magritte }
GtLRewriteDisplayOptions >> includeSourcesDescription [
	<magritteDescription>
	^ MABooleanDescription new
		label: 'Include sources';
		accessor: #includeSources;
		comment: 'Whether the listed methods have their newSource. Defaults to '
				, self class defaultIncludeSources printString , '.';
		beOptional
]

{ #category : #magritte }
GtLRewriteDisplayOptions >> snippetsLimitDescription [
	"A rewrite changes only methods"

	<magritteDescription>
	^ nil
]
