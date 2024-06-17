import { Colors } from "@/models/enums";

export const ICON_NAME_BY_COLOR: Partial<Record<Colors, string>> = {
  [Colors.PRIMARY]: "information-outline",
  [Colors.SUCCESS]: "check",
  [Colors.WARNING]: "alert",
  [Colors.DANGER]: "close",
};

export const ALLOWED_TYPES = [
  Colors.PRIMARY,
  Colors.SUCCESS,
  Colors.DANGER,
  Colors.WARNING,
];
