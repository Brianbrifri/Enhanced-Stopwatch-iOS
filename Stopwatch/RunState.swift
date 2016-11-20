import Foundation

//Gave enums a raw value to be able to store them in the core data
enum RunState: Int16 {
	case started = 1
	case stopped = 2
	case reset = 0
}
