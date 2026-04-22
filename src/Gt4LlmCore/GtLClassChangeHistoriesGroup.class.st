"
Group of class change histories.
"
Class {
	#name : #GtLClassChangeHistoriesGroup,
	#superclass : #GtLChangeHistoriesGroup,
	#category : #'Gt4LlmCore-Summaries'
}

{ #category : #accessing }
GtLClassChangeHistoriesGroup >> addHistory: aHistory [
	self add: aHistory
]

{ #category : #views }
GtLClassChangeHistoriesGroup >> gtViewHistoriesFor: aView [
	<gtView>
	^ aView columnedTree 
		title: 'By class';
		priority: 20;
		items: [ self items ];
		children: [ :anEntry | anEntry gtViewChangeHistoryChildren ];
		column: 'Change' do: [ :aColumn |
			aColumn
				cellStencil: [ GtLCodeChangesDetailsElement new ];
				dataBinder: [ :anElement :aCodeChange | anElement codeChange: aCodeChange ] ];
		column: 'Count' text: [ :anEntry | 
			| entryChangesCount |
			entryChangesCount := anEntry gtViewChangesCount.
			entryChangesCount isZero 
				ifTrue: ['']
				ifFalse: [
					entryChangesCount asString
						, ' '
							, ('change' asPluralBasedOn: entryChangesCount) ]] width: 100;
		column: 'Timestamp' text: [ :anEntry | 
			anEntry gtViewChangeEditTime
				ifNil: ['']
				ifNotNil: [ :aDateAndTime | 
					aDateAndTime printToSeconds ]  ] width: 150
]

{ #category : #accessing }
GtLClassChangeHistoriesGroup >> methodHistories [
	"Flatten all method histories from all class histories"
	^ GtLMethodChangeHistoriesGroup new
		addItems: (self items flatCollect: [ :aClassHistory | aClassHistory methodHistories items ]);
		yourself
]
