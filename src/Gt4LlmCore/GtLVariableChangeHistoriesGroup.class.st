"
Group of variable change histories. Created on demand by {{gtMethod:GtLClassDefinitionChangeHistory>>#variableChangeHistories}} for one class, and by {{gtMethod:GtLClassChangeHistoriesGroup>>#variableHistories}} across classes.
"
Class {
	#name : #GtLVariableChangeHistoriesGroup,
	#superclass : #GtLChangeHistoriesGroup,
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #adding }
GtLVariableChangeHistoriesGroup >> addHistory: aHistory [
	self add: aHistory
]

{ #category : #views }
GtLVariableChangeHistoriesGroup >> gtViewHistoriesFor: aView [
	<gtView>
	^ aView columnedTree
		title: 'By variable';
		priority: 20;
		items: [ self items ];
		children: [ :anEntry | anEntry gtViewChangeHistoryChildren ];
		column: 'Change'
			do: [ :aColumn | 
				aColumn
					cellStencil: [ GtLCodeChangesDetailsElement new ];
					dataBinder: [ :anElement :aCodeChange | anElement codeChange: aCodeChange ] ];
		column: 'Class'
			text: [ :anEntry | 
				(self items identityIncludes: anEntry)
					ifTrue: [ anEntry targetClassName ]
					ifFalse: [ '' ] ]
			width: 250;
		column: 'Count'
			text: [ :anEntry | 
				| entryChangesCount |
				entryChangesCount := anEntry gtViewChangesCount.
				entryChangesCount isZero
					ifTrue: [ '' ]
					ifFalse: [ entryChangesCount asString , ' '
							, ('change' asPluralBasedOn: entryChangesCount) ] ]
			width: 100
]

{ #category : #accessing }
GtLVariableChangeHistoriesGroup >> historyForVariableNamed: aVariableName type: aVariableType [
	^ self
		detect: [ :each | 
			each variableType = aVariableType
				and: [ each variableName = aVariableName asString ] ]
		ifNone: [ nil ]
]
