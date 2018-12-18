// swiftlint:disable all
// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command
// swiftlint:disable file_length

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name
internal enum L10n {

  internal enum Coodly {
    internal enum Feedback {
      internal enum Controller {
        /// Conversations
        internal static let title = L10n.tr("Localizable", "coodly.feedback.controller.title")
      }
      internal enum Header {
        /// Please read this before posting
        internal static let message = L10n.tr("Localizable", "coodly.feedback.header.message")
      }
      internal enum Message {
        internal enum Compose {
          internal enum Controller {
            /// Write message
            internal static let title = L10n.tr("Localizable", "coodly.feedback.message.compose.controller.title")
            internal enum Send {
              /// Send
              internal static let button = L10n.tr("Localizable", "coodly.feedback.message.compose.controller.send.button")
            }
          }
        }
      }
      internal enum Response {
        /// Hello\n\nI'm Jaanus Siim, independent developer based in Estonia.\n\nEvery suggestion and feedback is welcome. I promise to read them all. But I may not be able to respond to all messages.\n\nThanks for undertanding.
        internal static let notice = L10n.tr("Localizable", "coodly.feedback.response.notice")
      }
      internal enum Sign {
        internal enum In {
          /// Please sign in to iCloud to send a message.
          internal static let message = L10n.tr("Localizable", "coodly.feedback.sign.in.message")
        }
      }
    }
  }

  internal enum Kiosk {
    internal enum Posts {
      internal enum Controller {
        /// Gambrinus
        internal static let title = L10n.tr("Localizable", "kiosk.posts.controller.title")
      }
    }
  }

  internal enum Marked {
    internal enum Controller {
      /// Notables
      internal static let title = L10n.tr("Localizable", "marked.controller.title")
    }
  }

  internal enum Menu {
    internal enum Controller {
      internal enum Option {
        /// Favorites
        internal static let favorites = L10n.tr("Localizable", "menu.controller.option.favorites")
        /// Message to developer
        internal static let feedback = L10n.tr("Localizable", "menu.controller.option.feedback")
        internal enum All {
          /// All Posts
          internal static let posts = L10n.tr("Localizable", "menu.controller.option.all.posts")
        }
      }
      internal enum Sort {
        internal enum By {
          /// RB beer name
          internal static let beer = L10n.tr("Localizable", "menu.controller.sort.by.beer")
          /// brewer
          internal static let brewer = L10n.tr("Localizable", "menu.controller.sort.by.brewer")
          /// date
          internal static let date = L10n.tr("Localizable", "menu.controller.sort.by.date")
          /// post title
          internal static let posts = L10n.tr("Localizable", "menu.controller.sort.by.posts")
          /// RB score
          internal static let score = L10n.tr("Localizable", "menu.controller.sort.by.score")
          /// style
          internal static let style = L10n.tr("Localizable", "menu.controller.sort.by.style")
        }
        internal enum Section {
          /// Sort by
          internal static let title = L10n.tr("Localizable", "menu.controller.sort.section.title")
        }
      }
    }
  }

  internal enum Post {
    internal enum Extended {
      internal enum Details {
        internal enum Back {
          internal enum Button {
            /// Back
            internal static let title = L10n.tr("Localizable", "post.extended.details.back.button.title")
          }
        }
        internal enum Brewer {
          /// Brewer
          internal static let label = L10n.tr("Localizable", "post.extended.details.brewer.label")
        }
        internal enum Posted {
          internal enum On {
            /// Posted on
            internal static let label = L10n.tr("Localizable", "post.extended.details.posted.on.label")
          }
        }
        internal enum Style {
          /// Style
          internal static let label = L10n.tr("Localizable", "post.extended.details.style.label")
        }
      }
    }
  }

  internal enum Posts {
    internal enum Controller {
      /// All Posts
      internal static let title = L10n.tr("Localizable", "posts.controller.title")
      internal enum Edit {
        /// Edit
        internal static let button = L10n.tr("Localizable", "posts.controller.edit.button")
        internal enum Done {
          /// Done
          internal static let button = L10n.tr("Localizable", "posts.controller.edit.done.button")
        }
      }
    }
  }
}
// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name

// MARK: - Implementation Details

extension L10n {
  private static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
