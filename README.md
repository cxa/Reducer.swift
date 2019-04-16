# Reducer.swift

A small Swift lib inspired by [`React.useReducer`](https://reactjs.org/docs/hooks-reference.html#usereducer).

```swift
import Reducer

struct State {
  var count = 0
}

enum Action {
  case increment
  case decrement
}

func reducer(state: Reducer.Updater<State>, action: Action) {
  switch action {
  case .increment: state[keyPath: \.count] += 1
  case .decrement: state[keyPath: \.count] -= 1
  }
}

// state is a Reducer.Observer<State>
let (state, dispatch) = Reducer.use(initialState: State(), reducer: reducer)

// Return a `Observation` which can be invalidated later
let observation = state.observeKeyPath(\.count) { change in
  print(change.old)
  print(change.new)
  print(change.isInitial)
}

// Use action to notify state change
dispatch(.increment)

// If you want to disable the observation
observation.invalidate()
```