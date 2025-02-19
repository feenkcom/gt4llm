Extension { #name : #GtPharoMethodCoder }

{ #category : #'*Gt4Llm' }
GtPharoMethodCoder >> proposeTemporaryRenameIn: aSourceCoderViewModel node: aVariableNode usingChoices: aListOfChoices [
	| action locations announcement definer otherCoders renameAttributes originalSource |
	originalSource := (aSourceCoderViewModel styledText
			ifNil: [ aSourceCoderViewModel sourceText ])
			from: aVariableNode startPosition
			to: aVariableNode stopPosition.
	locations := OrderedCollection new.
	definer := aVariableNode whoDefines.
	announcement := GtCoderRenameTemporaryRequestedAnnouncement new.
	definer isNil
		ifTrue: [ announcement variableName: aVariableNode name source.
			self announce: announcement ].
	otherCoders := announcement interestedCoders reject: [ :each | each == self ].
	(definer ifNil: [ aVariableNode topParent ])
		withAllNodesDo: [ :each | each = aVariableNode ifTrue: [ locations add: each sourceInterval ] ].
	action := GtLlmCoderViewModelProposeRenameAction
			locations: locations
			textualCoderViewModel: aSourceCoderViewModel.
	action selectAll: true.
	action forVariableOrUnaryMessage.
	action choices: aListOfChoices.
	renameAttributes := OrderedCollection new.
	otherCoders
		do: [ :each | 
			each
				implicitVariableReferencesTo: aVariableNode variableName
				do: [ :node | 
					| attribute |
					attribute := GtRenamePreviewAttribute new text: originalSource.
					(each currentSourceText from: node startPosition to: node stopPosition)
						attributes: {attribute}.
					renameAttributes add: attribute ].
			each sourceChangedTo: each currentSourceText ].
	action
		when: GtRenameActionAnnouncement
		do: [ :ann | 
			ann eventType = #textUpdated
				ifTrue: [ renameAttributes
						do: [ :each | each updateText: ann renameAction newName asRopedText ] ].
			ann eventType = #uninstall
				ifTrue: [ otherCoders
						do: [ :each | 
							each currentSourceText
								clearAttributes: [ :attr | attr isKindOf: GtRenamePreviewAttribute ].
							each sourceChangedTo: each currentSourceText ] ].
			ann eventType = #accept
				ifTrue: [ otherCoders
						do: [ :each | each renameImplicitTemporary: aVariableNode variableName to: action newName ] ] ].
	action install.
	^ action
]
