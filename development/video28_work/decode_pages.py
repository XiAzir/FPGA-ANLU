"""Decode the C28 passive status pages, e.g. python decode_pages.py ED007803 FF810000."""
import argparse
import json

STATES = {
    0: "IDLE", 1: "DIV", 2: "DIV_FIN", 3: "SETUP", 4: "Y_BEGIN",
    5: "Y_NORM", 6: "ROW_CHECK", 7: "BYTE", 8: "SECTOR",
    9: "SECTOR_GAP", 10: "MEM_WAIT", 11: "BYTE_GOT", 12: "ROW_DONE",
    13: "X_BEGIN", 14: "X_MAP", 15: "ROW_READ", 16: "ROW_READ_WAIT",
    17: "EMIT", 18: "ADV_X", 19: "ADV_Y", 20: "TERMINAL", 21: "X_NORM",
}


def decode(text, photo_error=False):
    value = int(text, 16)
    page = value >> 28
    data = dict(hex=f"{value:08X}", page=f"{page:X}")
    if page == 0xE:
        data.update(
            hdmi_locked=(value >> 27) & 1, lock_seen=(value >> 26) & 1,
            lock_lost=(value >> 25) & 1, axis_ready=(value >> 24) & 1,
            sof_counter=(value >> 16) & 255,
            previous_frame_active_lines=(value >> 6) & 1023,
            axis_user=(value >> 5) & 1, axis_valid=(value >> 4) & 1,
            hs=(value >> 3) & 1, vs=(value >> 2) & 1,
            ready_wait_seen=(value >> 1) & 1, de_seen=value & 1,
        )
    elif page == 0xF:
        edges = (value >> 8) & 1023
        data.update(tmds_clock_word=f"{(value >> 18) & 1023:03X}",
                    pre_oddr_clock_edges_per_128_pixels=edges,
                    nominal_range_254_to_258=254 <= edges <= 258,
                    reserved_tail=f"{value & 255:02X}")
    elif page == 5:
        detail = (value >> 4) & 0xFFFFFF
        if photo_error:
            data.update(photo_failure_detail=f"{detail:06X}")
        else:
            state = detail >> 19
            data.update(scaler_state=state, scaler_state_name=STATES.get(state, "UNASSIGNED"),
                        output_y=(detail >> 10) & 511, output_x=detail & 1023)
        data.update(video_reader_error=(value >> 3) & 1, wav_error=(value >> 2) & 1,
                    display_valid=(value >> 1) & 1, video_mode=value & 1)
    elif page == 2:
        data.update(file_flags=f"{(value >> 20) & 255:02X}",
                    photo_state=(value >> 16) & 15, video_state=(value >> 12) & 15,
                    fs_error_code=f"{(value >> 4) & 255:02X}", consumer_errors=value & 15)
    return data


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("pages", nargs="+")
    parser.add_argument("--photo-error", action="store_true",
                        help="Decode page 5 as original failure detail when photo error is set")
    args = parser.parse_args()
    print(json.dumps([decode(page, args.photo_error) for page in args.pages],
                     ensure_ascii=False, indent=2))
