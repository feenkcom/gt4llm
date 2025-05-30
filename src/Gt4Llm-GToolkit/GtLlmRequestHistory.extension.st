Extension { #name : #GtLlmRequestHistory }

{ #category : #'*Gt4Llm-GToolkit' }
GtLlmRequestHistory >> gtClearHistoryActionFor: anAction [
	<gtAction>
	^ anAction button
		icon: BrGlamorousIcons trash;
		tooltip: 'Clear';
		priority: 80;
		action: [ :aButton :aTab | 
			self removeAll.
			aTab viewContentElement phlow update ]
]
